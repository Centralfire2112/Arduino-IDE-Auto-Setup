const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 6565;

// MIME types
const mimeTypes = {
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'text/javascript',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.bat': 'application/octet-stream'
};

const server = http.createServer((req, res) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);

    // Handle root path
    let filePath = req.url === '/' ? '/index.html' : req.url;
    
    // Remove query string
    filePath = filePath.split('?')[0];
    
    // Build full path
    const fullPath = path.join(__dirname, filePath);
    
    // Get file extension
    const ext = path.extname(fullPath).toLowerCase();
    const contentType = mimeTypes[ext] || 'application/octet-stream';

    // Check if file exists
    fs.access(fullPath, fs.constants.F_OK, (err) => {
        if (err) {
            // File not found
            res.writeHead(404, { 'Content-Type': 'text/html' });
            res.end('<h1>404 - File Not Found</h1>');
            console.log(`404 - File not found: ${fullPath}`);
            return;
        }

        // Special handling for .bat files - force download
        if (ext === '.bat') {
            const fileName = path.basename(fullPath);
            res.writeHead(200, {
                'Content-Type': 'application/octet-stream',
                'Content-Disposition': `attachment; filename="${fileName}"`
            });
            
            const fileStream = fs.createReadStream(fullPath);
            fileStream.pipe(res);
            console.log(`Download started: ${fileName}`);
            return;
        }

        // Serve other files normally
        fs.readFile(fullPath, (err, data) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'text/html' });
                res.end('<h1>500 - Internal Server Error</h1>');
                console.error(`Error reading file: ${err.message}`);
                return;
            }

            res.writeHead(200, { 'Content-Type': contentType });
            res.end(data);
        });
    });
});

server.listen(PORT, () => {
    console.log('========================================');
    console.log('  Arduino IDE Setup - Web Server');
    console.log('========================================');
    console.log(`Server running at http://localhost:${PORT}/`);
    console.log(`Network access: http://<your-ip>:${PORT}/`);
    console.log('');
    console.log('Press Ctrl+C to stop the server');
    console.log('========================================');
});

// Handle server errors
server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.error(`Error: Port ${PORT} is already in use.`);
        console.error('Please close the other application or change the port.');
    } else {
        console.error(`Server error: ${err.message}`);
    }
    process.exit(1);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n\nShutting down server...');
    server.close(() => {
        console.log('Server stopped.');
        process.exit(0);
    });
});
