const dgram = require('dgram');
const net = require('net');
const http = require('http');
const WebSocket = require('ws');
const fs = require('fs');
const path = require('path');
const os = require('os');

// ============================================
// КОНФИГУРАЦИЯ
// ============================================
const CONFIG = {
    UDP_PORT: 9000,
    UDP_BROADCAST: '255.255.255.255',
    HTTP_PORT: 8080,
    WS_PORT: 8081,
    LICENSES: {
        full: new Uint8Array([0x85, 0x83, 0x68, 0xE4, 0x03, 0xCB, 0xCE, 0x35, 0xC9, 0x8D, 0xC0, 0x2B, 0x62, 0x96, 0xCF, 0x26, 0x46, 0x90, 0x86, 0x38, 0xF6, 0x0E, 0xC4, 0xC5, 0x19, 0xC7])
    }
};

// ============================================
// СОСТОЯНИЕ СЕРВЕРА
// ============================================
const state = {
    converters: new Map(),
    controllers: new Map(),
    knownConverters: new Map(),
    wsClients: new Set(),
    logEnabled: true,
    cmdCounter: 0,
    pendingCommands: new Map(),
    logHistory: [],
    maxLogEntries: 500
};

// ============================================
// УТИЛИТЫ ДЛЯ РАБОТЫ С ПРОТОКОЛОМ
// ============================================
const ProtocolUtils = {
    in4out5(buf_in) {
        if (buf_in.byteLength % 4 !== 0) {
            console.error('in4out5: buf_in is not multiple of 4');
            return null;
        }
        const outLen = (buf_in.byteLength / 4) * 5;
        const out = new Uint8Array(outLen);
        const in8 = new Uint8Array(buf_in);
        let i = 0, k = 0;
        
        while (i < in8.length) {
            out[k] = ((in8[i] & 0x80) >> 4) + 
                     ((in8[i+1] & 0x80) >> 5) + 
                     ((in8[i+2] & 0x80) >> 6) + 
                     ((in8[i+3] & 0x80) >> 7);
            
            for (let j = 0; j < 4; j++) {
                out[k + j + 1] = in8[i + j] & 0x7F;
            }
            
            for (let j = 0; j < 5; j++) {
                if (out[k + j] < 0x30) {
                    out[k + j] = out[k + j] ^ 0xCA;
                }
            }
            
            i += 4;
            k += 5;
        }
        return out;
    },

    in5out4(buf_in) {
        if (buf_in.byteLength % 5 !== 0) {
            console.error('in5out4: buf_in is not multiple of 5');
            return null;
        }
        const outLen = (buf_in.byteLength / 5) * 4;
        const out = new Uint8Array(outLen);
        const in8 = new Uint8Array(buf_in);
        let i = 0, k = 0;
        
        while (i < in8.length) {
            for (let j = 0; j < 5; j++) {
                if (in8[i + j] & 0x80) {
                    in8[i + j] = in8[i + j] ^ 0xCA;
                }
            }
            
            for (let j = 0; j < 4; j++) {
                out[k + j] = in8[i + j] | (((in8[i + 4] >> j) & 1) << 7);
            }
            
            i += 5;
            k += 4;
        }
        return out;
    },

    check_out(buffer) {
        const buf = Buffer.from(buffer);
        let sum = 0;
        for (let i = 0; i < buf.length; i++) {
            sum += buf[i];
        }
        buf[0] = (0x100 - (sum & 0xFF)) & 0xFF;
        return buf;
    },

    check_in(buffer) {
        let sum = 0;
        for (let i = 0; i < buffer[1]; i++) {
            sum += buffer[i];
        }
        return (sum & 0xFF) === 0xFF;
    },

    createPacket(cmdType, licenseNum, cmdId, opCode, networkAddr, params, data) {
        const baseLen = 8;
        const dataLen = data ? data.length : 0;
        const totalLen = baseLen + dataLen;
        const paddedLen = Math.ceil(totalLen / 4) * 4;
        const packet = new Uint8Array(paddedLen);
        
        packet[1] = paddedLen;
        packet[2] = licenseNum;
        packet[3] = cmdId;
        packet[4] = opCode;
        packet[5] = networkAddr;
        
        if (params) {
            packet[6] = params[0] || 0;
            packet[7] = params[1] || 0;
        }
        
        if (data) {
            for (let i = 0; i < data.length && i < paddedLen - 8; i++) {
                packet[8 + i] = data[i];
            }
        }
        
        const result = this.check_out(packet);
        const encoded = this.in4out5(result);
        
        const finalCmd = new Uint8Array(1 + encoded.length + 1);
        finalCmd[0] = cmdType;
        for (let i = 0; i < encoded.length; i++) {
            finalCmd[i + 1] = encoded[i];
        }
        finalCmd[finalCmd.length - 1] = 0x0D;
        
        return Buffer.from(finalCmd);
    },

    parseResponse(data) {
        if (data.length === 0) return null;
        
        if (data[0] === 0x02) {
            const errorMsg = this.parseError(data);
            return { error: true, message: errorMsg };
        }
        
        if (data[0] === 0x69 || data[0] === 0xC8 || data[0] === 0x4C) {
            return { type: 'short', data: data.toString('ascii') };
        }
        
        if (data[0] === 0x1E || data[0] === 0x1F || data[0] === 0x20) {
            const packetData = data.slice(1, data.length - 1);
            const decoded = this.in5out4(packetData);
            if (decoded) {
                return { type: 'packet', data: Buffer.from(decoded) };
            }
        }
        
        return { type: 'unknown', data: data };
    },

    parseError(data) {
        if (data.length < 3) return 'Unknown error';
        const code = data.slice(1, data.length - 1).toString('ascii');
        const errors = {
            'HH': 'Ошибка в контрольной сумме или при преобразовании',
            'HLC': 'Недопустимая команда при работе с лицензиями',
            'HC': 'Попытка обращения к неизвестному контроллеру',
            'HL1': 'Лицензия не активирована',
            'HL2': 'Лицензия устарела',
            'HL3': 'Количество контроллеров превышает лицензионное ограничение',
            'HL4': 'Ошибка чтения - количество карт превышает лицензионное ограничение',
            'HL5': 'Ошибка записи - количество карт превышает лицензионное ограничение',
            'HL6': 'Ошибка записи - лицензия устарела',
            'HJ': 'Ошибка формата пакета - недопустимый первый байт'
        };
        return errors[code] || `Unknown error: ${code}`;
    },

    parseLicenseList(text) {
        const licenses = {};
        const parts = text.split(' ');
        for (const part of parts) {
            if (part.includes('(')) {
                const match = part.match(/(\d+)\((\d+)\/(\d+)\)/);
                if (match) {
                    licenses[parseInt(match[1])] = {
                        controllers: parseInt(match[2]),
                        cards: parseInt(match[3])
                    };
                }
            }
        }
        return licenses;
    },

    getCommandName(cmdType, opCode) {
        const commands = {
            '0x69': 'Полная информация о конвертере',
            '0xC8': 'Краткая информация о конвертере',
            '0x4C': 'Список лицензий',
            '0x1E_0x01': 'Чтение лицензий',
            '0x1E_0x02': 'Установка лицензии',
            '0x1F_0x02': 'Чтение памяти контроллера',
            '0x1F_0x03': 'Запись памяти контроллера',
            '0x1F_0x07': 'Открытие двери',
            '0x20_0x00': 'Поиск контроллеров',
        };
        const key = `0x${cmdType.toString(16).padStart(2, '0')}_0x${opCode.toString(16).padStart(2, '0')}`;
        return commands[key] || `Команда 0x${cmdType.toString(16)} op:0x${opCode.toString(16)}`;
    },

    decodeResponse(data, type) {
        if (type === 'short') {
            return data;
        }
        if (type === 'packet' && data) {
            const bytes = new Uint8Array(data);
            if (bytes.length >= 21 && bytes[4] === 0x00 && bytes[5] === 0x00) {
                const mask = bytes.slice(8, 21);
                const controllers = [];
                for (let i = 0; i < mask.length; i++) {
                    for (let bit = 0; bit < 8; bit++) {
                        if (mask[i] & (1 << bit)) {
                            const addr = (i * 8) + bit + 2;
                            if (addr >= 2 && addr <= 105) {
                                controllers.push(addr);
                            }
                        }
                    }
                }
                if (controllers.length > 0) {
                    return `Найдены контроллеры: ${controllers.join(', ')}`;
                }
                return 'Контроллеры не найдены (адреса 2-105)';
            }
            return `Данные: ${bytes.toString('hex')}`;
        }
        return '';
    }
};

// ============================================
// УПРАВЛЕНИЕ КОНВЕРТЕРАМИ
// ============================================
class ConverterManager {
    constructor() {
        this.connections = new Map();
    }

    connect(ip, port) {
        return new Promise((resolve, reject) => {
            if (state.converters.has(ip) && state.converters.get(ip).connected) {
                resolve(state.converters.get(ip));
                return;
            }

            if (state.converters.has(ip) && state.converters.get(ip).blocked) {
                reject(new Error('Converter is blocked'));
                return;
            }

            console.log(`[${new Date().toISOString()}] Connecting to converter ${ip}:${port}...`);

            this.addLog('info', `Подключение к конвертеру ${ip}:${port}`);

            const socket = new net.Socket();
            const timeout = setTimeout(() => {
                socket.destroy();
                reject(new Error('Connection timeout'));
            }, 5000);

            socket.connect(port, ip, () => {
                clearTimeout(timeout);
                socket.setKeepAlive(true);
                
                const converterInfo = {
                    socket,
                    ip,
                    port,
                    connected: true,
                    blocked: false,
                    info: null,
                    controllers: [],
                    activeController: null,
                    license: null,
                    licenseInstalled: false,
                    pendingCommand: null,
                    lastCommand: null
                };
                
                state.converters.set(ip, converterInfo);
                this.setupSocketHandlers(socket, ip);
                this.switchToAdvanced(socket);
                
                console.log(`[${new Date().toISOString()}] Connected to converter ${ip}:${port}`);
                this.addLog('info', `Конвертер ${ip} подключен`);
                
                this.broadcastToWS({
                    type: 'converters',
                    data: this.getConvertersList()
                });
                
                resolve(converterInfo);
            });

            socket.on('error', (err) => {
                clearTimeout(timeout);
                console.error(`[${new Date().toISOString()}] Connection error to ${ip}:${port} - ${err.message}`);
                this.addLog('error', `Ошибка подключения к ${ip}: ${err.message}`);
                reject(err);
            });
        });
    }

    setupSocketHandlers(socket, ip) {
        let buffer = Buffer.alloc(0);
        
        socket.on('data', (data) => {
            buffer = Buffer.concat([buffer, data]);
            
            let pos = 0;
            while (pos < buffer.length) {
                const endPos = buffer.indexOf(0x0D, pos);
                if (endPos === -1) break;
                
                const packet = buffer.slice(pos, endPos + 1);
                pos = endPos + 1;
                this.handleResponse(ip, packet);
            }
            
            buffer = buffer.slice(pos);
        });

        socket.on('close', () => {
            const info = state.converters.get(ip);
            if (info) {
                info.connected = false;
                console.log(`[${new Date().toISOString()}] Converter ${ip} disconnected`);
                this.addLog('info', `Конвертер ${ip} отключен`);
                this.broadcastToWS({
                    type: 'converterDisconnected',
                    ip: ip
                });
            }
        });

        socket.on('error', (err) => {
            console.error(`[${new Date().toISOString()}] Socket error for ${ip}:`, err.message);
            this.addLog('error', `Ошибка сокета для ${ip}: ${err.message}`);
        });
    }

    handleResponse(ip, data) {
        const converter = state.converters.get(ip);
        if (!converter) return;

        const parsed = ProtocolUtils.parseResponse(data);
        
        if (parsed && parsed.error) {
            this.addLog('error', `Ошибка от ${ip}: ${parsed.message}`);
            this.broadcastToWS({
                type: 'error',
                converter: ip,
                message: parsed.message
            });
            if (converter.pendingCommand) {
                converter.pendingCommand.resolve(parsed);
                converter.pendingCommand = null;
            }
            return;
        }
        
        let cmdName = 'Ответ';
        if (converter.lastCommand) {
            cmdName = ProtocolUtils.getCommandName(converter.lastCommand.type, converter.lastCommand.opCode || 0);
        }

        const sent = converter.lastCommand ? converter.lastCommand.bytes : '';
        const received = data.toString('hex');
        let decoded = '';
        
        if (parsed) {
            if (parsed.type === 'short') {
                decoded = parsed.data;
            } else {
                decoded = ProtocolUtils.decodeResponse(parsed.data, parsed.type);
            }
        }

        let displayReceived = received;
        if (parsed && parsed.type === 'short') {
            displayReceived = parsed.data;
        }

        this.addLog('response', {
            command: cmdName,
            sent: sent,
            received: displayReceived,
            decoded: decoded
        });

        if (converter.pendingCommand) {
            const { resolve } = converter.pendingCommand;
            converter.pendingCommand = null;
            resolve(parsed);
        }

        this.broadcastToWS({
            type: 'response',
            converter: ip,
            command: cmdName,
            sent: sent,
            received: displayReceived,
            decoded: decoded,
            parsed: parsed
        });
    }

    addLog(type, data) {
        const entry = {
            time: new Date().toLocaleTimeString(),
            type: type,
            data: data
        };
        state.logHistory.push(entry);
        if (state.logHistory.length > state.maxLogEntries) {
            state.logHistory.shift();
        }
        this.broadcastToWS({
            type: 'log',
            entry: entry
        });
    }

    broadcastToWS(message) {
        state.wsClients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(JSON.stringify(message));
            }
        });
    }

    switchToAdvanced(socket) {
        const cmd = Buffer.from([0xFF, 0xFA, 0x2C, 0x01, 0x00, 0x03, 0x84, 0x00, 0xFF, 0xF0]);
        socket.write(cmd);
        console.log('[ADVANCED] Sent mode switch command (230400 baud)');
        this.addLog('info', 'Отправлена команда переключения в Advanced режим');
    }

    sendShortCommand(ip, cmdType) {
        return new Promise((resolve, reject) => {
            const converter = state.converters.get(ip);
            if (!converter || !converter.connected) {
                reject(new Error('Converter not connected'));
                return;
            }

            const command = Buffer.from([cmdType, 0x0D]);
            const cmdName = ProtocolUtils.getCommandName(cmdType, 0);
            
            converter.lastCommand = {
                type: cmdType,
                opCode: 0,
                bytes: command.toString('hex')
            };

            converter.pendingCommand = { resolve, reject };

            this.addLog('command', {
                name: cmdName,
                bytes: command.toString('hex')
            });

            try {
                converter.socket.write(command);
            } catch (err) {
                converter.pendingCommand = null;
                this.addLog('error', `Ошибка отправки ${cmdName}: ${err.message}`);
                reject(err);
            }
        });
    }

    sendCommand(ip, command, timeout = 5000) {
        return new Promise((resolve, reject) => {
            const converter = state.converters.get(ip);
            if (!converter || !converter.connected) {
                reject(new Error('Converter not connected'));
                return;
            }

            if (converter.blocked) {
                reject(new Error('Converter is blocked'));
                return;
            }

            const cmdId = ++state.cmdCounter;
            converter.pendingCommand = { resolve, reject, cmdId };

            const timeoutId = setTimeout(() => {
                converter.pendingCommand = null;
                reject(new Error('Command timeout'));
            }, timeout);

            try {
                converter.socket.write(command);
            } catch (err) {
                clearTimeout(timeoutId);
                converter.pendingCommand = null;
                reject(err);
            }
        });
    }

    async scanControllers(ip) {
        const converter = state.converters.get(ip);
        if (!converter) throw new Error('Converter not found');

        const cmdId = ++state.cmdCounter;
        const packet = ProtocolUtils.createPacket(
            0x20, 0x08, cmdId, 0x00, 0x00, [0x00, 0x00]
        );
        
        converter.lastCommand = {
            type: 0x20,
            opCode: 0x00,
            bytes: packet.toString('hex')
        };

        this.addLog('command', {
            name: 'Поиск контроллеров',
            bytes: packet.toString('hex')
        });

        const response = await this.sendCommand(ip, packet);
        
        if (response && response.type === 'packet' && response.data) {
            const mask = response.data.slice(8, 21);
            const controllers = [];
            
            for (let i = 0; i < mask.length; i++) {
                for (let bit = 0; bit < 8; bit++) {
                    if (mask[i] & (1 << bit)) {
                        const addr = (i * 8) + bit + 2;
                        if (addr >= 2 && addr <= 105) {
                            controllers.push(addr);
                        }
                    }
                }
            }
            
            converter.controllers = controllers;
            
            for (const addr of controllers) {
                if (addr >= 2 && addr <= 105) {
                    try {
                        const info = await this.getControllerInfo(ip, addr);
                        state.controllers.set(`${ip}_${addr}`, { 
                            converter_ip: ip, 
                            addr: addr, 
                            info: info 
                        });
                    } catch (err) {
                        console.error(`Failed to get info for controller ${addr}:`, err.message);
                    }
                }
            }
            
            this.addLog('info', `Найдено контроллеров: ${controllers.length}`);
            
            this.broadcastToWS({
                type: 'controllersScanned',
                ip: ip,
                controllers: controllers,
                list: Array.from(state.controllers.values())
            });
            
            return controllers;
        }
        
        throw new Error('Controller scan failed');
    }

    async getControllerInfo(ip, addr) {
        const converter = state.converters.get(ip);
        if (!converter) throw new Error('Converter not found');

        const cmdId = ++state.cmdCounter;
        const packet = ProtocolUtils.createPacket(
            0x20, 0x08, cmdId, 0x00, addr, [0x01, 0x00]
        );
        
        converter.lastCommand = {
            type: 0x20,
            opCode: 0x00,
            bytes: packet.toString('hex')
        };

        this.addLog('command', {
            name: `Информация о контроллере #${addr}`,
            bytes: packet.toString('hex')
        });

        const response = await this.sendCommand(ip, packet);
        
        if (response && response.type === 'packet' && response.data) {
            const data = response.data;
            const info = {
                serialNumber: (data[6] << 8) | data[7],
                type: data[8],
                typeName: this.getControllerType(data[8]),
                params: data[9],
                memorySize: this.getMemorySize(data[9] & 0x03),
                wiegand: !!(data[9] & 0x08),
                joinMode: !!(data[9] & 0x10),
                hasTwoBanks: !!(data[9] & 0x40),
                hasNewEvents: !!(data[9] & 0x80),
                firmwareVersion: (data[10] << 8) | data[11],
                lastEventAddr: (data[13] << 8) | data[14],
                lastReadEventAddr: (data[15] << 8) | data[16]
            };
            
            return info;
        }
        
        throw new Error('Failed to get controller info');
    }

    getControllerType(type) {
        const types = {
            0x24: 'Matrix-II-Net',
            0x25: 'ZSR-Net',
            0x27: 'Guard-Net'
        };
        return types[type] || `Unknown (0x${type.toString(16)})`;
    }

    getMemorySize(code) {
        const sizes = { 0x00: '2KB', 0x01: '4KB', 0x02: '8KB' };
        return sizes[code] || 'Unknown';
    }

    async openDoor(ip, addr, direction = 0) {
        const converter = state.converters.get(ip);
        if (!converter) throw new Error('Converter not found');

        const cmdId = ++state.cmdCounter;
        const packet = ProtocolUtils.createPacket(
            0x1F, 0x08, cmdId, 0x07, addr, [direction, 0x00]
        );
        
        converter.lastCommand = {
            type: 0x1F,
            opCode: 0x07,
            bytes: packet.toString('hex')
        };

        this.addLog('command', {
            name: `Открытие двери #${addr}`,
            bytes: packet.toString('hex')
        });

        return await this.sendCommand(ip, packet);
    }

    async readMemory(ip, addr, blockType, blockNum, offset, length) {
        const converter = state.converters.get(ip);
        if (!converter) throw new Error('Converter not found');

        const cmdId = ++state.cmdCounter;
        const packet = ProtocolUtils.createPacket(
            0x1F, 0x08, cmdId, 0x02, addr, [0x00, 0x00],
            new Uint8Array([blockType, blockNum, (offset >> 8) & 0xFF, offset & 0xFF, (length >> 8) & 0xFF, length & 0xFF])
        );
        
        converter.lastCommand = {
            type: 0x1F,
            opCode: 0x02,
            bytes: packet.toString('hex')
        };

        this.addLog('command', {
            name: `Чтение памяти #${addr}`,
            bytes: packet.toString('hex')
        });

        return await this.sendCommand(ip, packet);
    }

    async writeMemory(ip, addr, blockType, blockNum, offset, data) {
        const converter = state.converters.get(ip);
        if (!converter) throw new Error('Converter not found');

        const cmdId = ++state.cmdCounter;
        const packet = ProtocolUtils.createPacket(
            0x1F, 0x08, cmdId, 0x03, addr, [0x00, 0x00],
            new Uint8Array([blockType, blockNum, (offset >> 8) & 0xFF, offset & 0xFF, data.length, ...data])
        );
        
        converter.lastCommand = {
            type: 0x1F,
            opCode: 0x03,
            bytes: packet.toString('hex')
        };

        this.addLog('command', {
            name: `Запись памяти #${addr}`,
            bytes: packet.toString('hex')
        });

        return await this.sendCommand(ip, packet);
    }

    setActiveController(ip, addr) {
        const converter = state.converters.get(ip);
        if (converter) {
            converter.activeController = addr;
            this.addLog('info', `Активный контроллер на ${ip}: #${addr}`);
            this.broadcastToWS({
                type: 'activeControllerChanged',
                ip: ip,
                addr: addr
            });
        }
    }

    getConvertersList() {
        const list = [];
        for (const [ip, conv] of state.converters) {
            list.push({
                ip: ip,
                port: conv.port,
                connected: conv.connected,
                blocked: conv.blocked,
                controllers: conv.controllers || [],
                activeController: conv.activeController,
                info: conv.info
            });
        }
        return list;
    }

    toggleLog() {
        state.logEnabled = !state.logEnabled;
        this.broadcastToWS({
            type: 'logToggled',
            enabled: state.logEnabled
        });
    }
}

// ============================================
// HTTP СЕРВЕР И WEB-ИНТЕРФЕЙС
// ============================================
class WebServer {
    constructor(converterManager) {
        this.manager = converterManager;
        this.httpServer = http.createServer(this.handleRequest.bind(this));
        this.wsServer = null;
        this.htmlPath = path.join(__dirname, 'index.html');
    }

    start(port = CONFIG.HTTP_PORT, wsPort = CONFIG.WS_PORT) {
        this.httpServer.listen(port, () => {
            this.showServerInfo(port, wsPort);
        });

        this.wsServer = new WebSocket.Server({ port: wsPort });
        this.setupWebSocket();

        return this;
    }

    showServerInfo(httpPort, wsPort) {
        console.log('\n========================================');
        console.log('Z-397 Guard Protocol Server');
        console.log('========================================');
        console.log(`Local: http://localhost:${httpPort}`);
        console.log(`WebSocket: ws://localhost:${wsPort}`);
        
        const interfaces = os.networkInterfaces();
        for (const [name, iface] of Object.entries(interfaces)) {
            for (const addr of iface) {
                if (!addr.internal && addr.family === 'IPv4') {
                    console.log(`Network: http://${addr.address}:${httpPort}`);
                    console.log(`WebSocket: ws://${addr.address}:${wsPort}`);
                }
            }
        }
        console.log('========================================');
        console.log(`UDP Scanner: broadcasting "SEEK Z397IP" on port ${CONFIG.UDP_PORT}`);
        console.log('Press Ctrl+C to stop');
        console.log('========================================\n');
    }

    setupWebSocket() {
        this.wsServer.on('connection', (ws) => {
            state.wsClients.add(ws);
            
            ws.send(JSON.stringify({
                type: 'state',
                converters: this.manager.getConvertersList(),
                controllers: Array.from(state.controllers.values()),
                logHistory: state.logHistory,
                logEnabled: state.logEnabled
            }));

            ws.on('message', (message) => {
                try {
                    const data = JSON.parse(message);
                    this.handleWebSocketCommand(ws, data);
                } catch (err) {
                    ws.send(JSON.stringify({
                        type: 'error',
                        message: err.message
                    }));
                }
            });

            ws.on('close', () => {
                state.wsClients.delete(ws);
            });
        });
    }

    handleWebSocketCommand(ws, command) {
        switch (command.action) {
            case 'getConverters':
                ws.send(JSON.stringify({
                    type: 'converters',
                    data: this.manager.getConvertersList()
                }));
                break;

            case 'getControllers':
                ws.send(JSON.stringify({
                    type: 'controllers',
                    data: Array.from(state.controllers.values())
                }));
                break;

            case 'connectConverter':
                this.connectConverter(ws, command.ip);
                break;

            case 'fullInfo':
                this.fullInfo(ws, command.ip);
                break;

            case 'shortInfo':
                this.shortInfo(ws, command.ip);
                break;

            case 'licenseList':
                this.licenseList(ws, command.ip);
                break;

            case 'scanControllers':
                this.scanControllers(ws, command.ip);
                break;

            case 'getControllerInfo':
                this.getControllerInfo(ws, command.ip, command.addr);
                break;

            case 'openDoor':
                this.openDoor(ws, command.ip, command.addr, command.direction);
                break;

            case 'readMemory':
                this.readMemory(ws, command.ip, command.addr, command.blockType, command.blockNum, command.offset, command.length);
                break;

            case 'writeMemory':
                this.writeMemory(ws, command.ip, command.addr, command.blockType, command.blockNum, command.offset, command.data);
                break;

            case 'setActiveController':
                this.manager.setActiveController(command.ip, command.addr);
                break;

            case 'blockConverter':
                this.blockConverter(ws, command.ip);
                break;

            case 'unblockConverter':
                this.unblockConverter(ws, command.ip);
                break;

            case 'removeConverter':
                this.removeConverter(ws, command.ip);
                break;

            case 'clearAllConverters':
                this.clearAllConverters(ws);
                break;

            case 'clearAllControllers':
                this.clearAllControllers(ws);
                break;

            case 'toggleLog':
                this.toggleLog(ws);
                break;

            default:
                ws.send(JSON.stringify({
                    type: 'error',
                    message: `Unknown action: ${command.action}`
                }));
        }
    }

    async connectConverter(ws, ip) {
        try {
            await this.manager.connect(ip, 1000);
            ws.send(JSON.stringify({
                type: 'converterConnected',
                ip: ip,
                success: true
            }));
            
            ws.send(JSON.stringify({
                type: 'converters',
                data: this.manager.getConvertersList()
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to connect to ${ip}: ${err.message}`
            }));
        }
    }

    async fullInfo(ws, ip) {
        try {
            const result = await this.manager.sendShortCommand(ip, 0x69);
            ws.send(JSON.stringify({
                type: 'fullInfoResult',
                ip: ip,
                data: result
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to get full info: ${err.message}`
            }));
        }
    }

    async shortInfo(ws, ip) {
        try {
            const result = await this.manager.sendShortCommand(ip, 0xC8);
            ws.send(JSON.stringify({
                type: 'shortInfoResult',
                ip: ip,
                data: result
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to get short info: ${err.message}`
            }));
        }
    }

    async licenseList(ws, ip) {
        try {
            const result = await this.manager.sendShortCommand(ip, 0x4C);
            ws.send(JSON.stringify({
                type: 'licenseListResult',
                ip: ip,
                data: result
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to get license list: ${err.message}`
            }));
        }
    }

    async scanControllers(ws, ip) {
        try {
            const controllers = await this.manager.scanControllers(ip);
            ws.send(JSON.stringify({
                type: 'scanResult',
                ip: ip,
                controllers: controllers
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to scan controllers: ${err.message}`
            }));
        }
    }

    async getControllerInfo(ws, ip, addr) {
        try {
            const info = await this.manager.getControllerInfo(ip, addr);
            ws.send(JSON.stringify({
                type: 'controllerInfoResult',
                ip: ip,
                addr: addr,
                info: info
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to get controller info: ${err.message}`
            }));
        }
    }

    async openDoor(ws, ip, addr, direction = 0) {
        try {
            await this.manager.openDoor(ip, addr, direction);
            ws.send(JSON.stringify({
                type: 'doorOpened',
                ip: ip,
                addr: addr,
                success: true
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to open door: ${err.message}`
            }));
        }
    }

    async readMemory(ws, ip, addr, blockType, blockNum, offset, length) {
        try {
            const result = await this.manager.readMemory(ip, addr, blockType, blockNum, offset, length);
            ws.send(JSON.stringify({
                type: 'memoryReadResult',
                ip: ip,
                addr: addr,
                data: result
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to read memory: ${err.message}`
            }));
        }
    }

    async writeMemory(ws, ip, addr, blockType, blockNum, offset, data) {
        try {
            await this.manager.writeMemory(ip, addr, blockType, blockNum, offset, data);
            ws.send(JSON.stringify({
                type: 'memoryWriteResult',
                ip: ip,
                addr: addr,
                success: true
            }));
        } catch (err) {
            ws.send(JSON.stringify({
                type: 'error',
                message: `Failed to write memory: ${err.message}`
            }));
        }
    }

    blockConverter(ws, ip) {
        const conv = state.converters.get(ip);
        if (conv) {
            conv.blocked = true;
            this.manager.addLog('info', `Конвертер ${ip} заблокирован`);
            ws.send(JSON.stringify({
                type: 'converterBlocked',
                ip: ip
            }));
        }
    }

    unblockConverter(ws, ip) {
        const conv = state.converters.get(ip);
        if (conv) {
            conv.blocked = false;
            this.manager.addLog('info', `Конвертер ${ip} разблокирован`);
            ws.send(JSON.stringify({
                type: 'converterUnblocked',
                ip: ip
            }));
        }
    }

    removeConverter(ws, ip) {
        const conv = state.converters.get(ip);
        if (conv && conv.socket) {
            conv.socket.destroy();
        }
        state.converters.delete(ip);
        this.manager.addLog('info', `Конвертер ${ip} удален`);
        ws.send(JSON.stringify({
            type: 'converterRemoved',
            ip: ip
        }));
    }

    clearAllConverters(ws) {
        for (const [ip, conv] of state.converters) {
            if (conv.socket) {
                conv.socket.destroy();
            }
        }
        state.converters.clear();
        this.manager.addLog('info', 'Все конвертеры очищены');
        ws.send(JSON.stringify({
            type: 'allConvertersCleared'
        }));
    }

    clearAllControllers(ws) {
        state.controllers.clear();
        for (const [ip, conv] of state.converters) {
            conv.controllers = [];
            conv.activeController = null;
        }
        this.manager.addLog('info', 'Все контроллеры очищены');
        ws.send(JSON.stringify({
            type: 'allControllersCleared'
        }));
    }

    toggleLog(ws) {
        this.manager.toggleLog();
        ws.send(JSON.stringify({
            type: 'logToggled',
            enabled: state.logEnabled
        }));
    }

    handleRequest(req, res) {
        if (req.url === '/') {
            this.serveHTML(res);
        } else if (req.url === '/api' && req.method === 'POST') {
            this.handleAPI(req, res);
        } else {
            res.writeHead(404);
            res.end('Not found');
        }
    }

    serveHTML(res) {
        try {
            const html = fs.readFileSync(this.htmlPath, 'utf8');
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(html);
        } catch (err) {
            console.error('Error reading index.html:', err.message);
            res.writeHead(500);
            res.end(`
                <h1>Error: index.html not found</h1>
                <p>Please create index.html in the same directory as server.js</p>
                <p>Error: ${err.message}</p>
            `);
        }
    }

    async handleAPI(req, res) {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', async () => {
            try {
                const data = JSON.parse(body);
                const result = await this.handleAPICommand(data);
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify(result));
            } catch (err) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: err.message }));
            }
        });
    }

    async handleAPICommand(command) {
        switch (command.action) {
            case 'getConverters':
                return { success: true, data: this.manager.getConvertersList() };
            case 'getControllers':
                return { success: true, data: Array.from(state.controllers.values()) };
            case 'connectConverter':
                await this.manager.connect(command.ip, 1000);
                return { success: true };
            case 'fullInfo':
                return await this.manager.sendShortCommand(command.ip, 0x69);
            case 'shortInfo':
                return await this.manager.sendShortCommand(command.ip, 0xC8);
            case 'licenseList':
                return await this.manager.sendShortCommand(command.ip, 0x4C);
            case 'scanControllers':
                return await this.manager.scanControllers(command.ip);
            case 'getControllerInfo':
                return await this.manager.getControllerInfo(command.ip, command.addr);
            case 'openDoor':
                return await this.manager.openDoor(command.ip, command.addr, command.direction);
            default:
                throw new Error(`Unknown action: ${command.action}`);
        }
    }
}

// ============================================
// UDP ПОИСК КОНВЕРТЕРОВ
// ============================================
class UDPScanner {
    constructor(manager) {
        this.manager = manager;
        this.socket = null;
        this.initSocket();
    }

    initSocket() {
        try {
            this.socket = dgram.createSocket({
                type: 'udp4',
                reuseAddr: true
            });

            this.socket.on('listening', () => {
                const address = this.socket.address();
                console.log(`[UDP] Scanner listening on ${address.address}:${address.port}`);
                this.socket.setBroadcast(true);
                setTimeout(() => this.broadcastSearch(), 1000);
            });

            this.socket.on('message', (message, rinfo) => {
                try {
                    if (this.socket.address() && rinfo.address === this.socket.address().address) {
                        return;
                    }
                    
                    const str = message.toString('ascii').trim();
                    
                    if (str === 'SEEK Z397IP') {
                        return;
                    }
                    
                    this.manager.addLog('udp', `📥 UDP ответ от ${rinfo.address}: ${str}`);
                    
                    const response = this.parseResponse(message, rinfo);
                    if (response) {
                        this.manager.addLog('info', `Найден конвертер: ${response.ip}:${response.port} (SN: ${response.sn})`);
                        this.handleConverterFound(response);
                    }
                } catch (err) {
                    console.error('[UDP] Error parsing message:', err);
                }
            });

            this.socket.on('error', (err) => {
                console.error('[UDP] Socket error:', err);
                setTimeout(() => {
                    console.log('[UDP] Reinitializing socket...');
                    this.initSocket();
                }, 5000);
            });

            this.socket.bind(CONFIG.UDP_PORT);

            this.searchInterval = setInterval(() => {
                this.broadcastSearch();
            }, 3000);

        } catch (err) {
            console.error('[UDP] Failed to initialize socket:', err);
        }
    }

    parseResponse(message, rinfo) {
        const str = message.toString('ascii').trim();
        const msg = { from: rinfo.address };
        const arr = str.split(' ');
        
        for (const item of arr) {
            const parts = item.split(':');
            if (parts.length > 1) {
                msg[parts[0]] = parts[1];
            } else if (item.includes('SN')) {
                const ind = item.indexOf('SN');
                msg.number = item.substring(ind + 2);
            }
        }
        
        if (msg.L1_Port && msg.L2_Port) {
            const port = parseInt(msg.L1_Port) || 1000;
            if (msg.L1_Conn === '0.0.0.0' && msg.L2_Conn === '0.0.0.0') {
                return { 
                    ip: msg.from, 
                    port: port,
                    sn: msg.number,
                    sw: msg['Z397-WEB-SW'],
                    lock: msg.Lock
                };
            }
        }
        return null;
    }

    handleConverterFound(info) {
        state.knownConverters.set(info.ip, {
            ip: info.ip,
            port: info.port,
            sn: info.sn,
            sw: info.sw,
            lastSeen: new Date()
        });

        if (!state.converters.has(info.ip) && !state.converters.get(info.ip)?.blocked) {
            console.log(`[UDP] Auto-connecting to ${info.ip}:${info.port}`);
            this.manager.addLog('info', `Автоподключение к ${info.ip}:${info.port}`);
            setTimeout(() => {
                this.autoConnect(info.ip, info.port);
            }, 1000);
        }
    }

    async autoConnect(ip, port) {
        try {
            if (!state.converters.has(ip)) {
                await this.manager.connect(ip, port);
                console.log(`[UDP] Successfully connected to ${ip}:${port}`);
            }
        } catch (err) {
            console.log(`[UDP] Failed to connect to ${ip}:${port} - ${err.message}`);
            this.manager.addLog('error', `Ошибка подключения к ${ip}:${err.message}`);
        }
    }

    broadcastSearch() {
        try {
            const message = Buffer.from("SEEK Z397IP");
            this.socket.send(message, 0, message.length, CONFIG.UDP_PORT, CONFIG.UDP_BROADCAST);
            this.manager.addLog('udp', '📤 UDP поиск: SEEK Z397IP');
        } catch (err) {
            console.error('[UDP] Failed to broadcast:', err);
        }
    }
}

// ============================================
// ЗАПУСК СЕРВЕРА
// ============================================
const manager = new ConverterManager();
const webServer = new WebServer(manager);
const udpScanner = new UDPScanner(manager);

webServer.start(CONFIG.HTTP_PORT, CONFIG.WS_PORT);

module.exports = {
    manager,
    webServer,
    udpScanner,
    state,
    CONFIG,
    ProtocolUtils
};

process.on('SIGINT', () => {
    console.log('\nShutting down...');
    for (const [ip, conv] of state.converters) {
        if (conv.socket) {
            conv.socket.destroy();
        }
    }
    process.exit(0);
});

process.on('uncaughtException', (err) => {
    console.error('Uncaught exception:', err);
});

console.log('Z-397 Guard Protocol Server starting...');