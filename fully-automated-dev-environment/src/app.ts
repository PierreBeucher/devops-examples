import * as http from 'http'
import * as mysql from 'mysql2'

export function startServer() {
    const hostname = '127.0.0.1';
    const port = 3000;

    const server = http.createServer((req, res) => {
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/plain');
        res.end('Hello World');
    });

    server.listen(port, hostname, () => {
        console.log(`Server running at http://${hostname}:${port}/`);
    });
}


/**
 * Connect to MySQL
 * Creds are provided as env var
 */
export function connectMysql(){
    const mysqlHost = "localhost"
    const mysqlPort = "3306"
    const mysqlUser = process.env.MYSQL_USER
    const mysqlPassword = process.env.MYSQL_PASSWORD

    console.log(`Authenticating to MySQL server ${mysqlHost}:${mysqlPort} with user ${mysqlUser}'`);

    var con = mysql.createConnection({
        host: "localhost",
        port: 3306,
        user: mysqlUser,
        password: mysqlPassword
    });

    con.connect(function(err) {
        if (err) throw err;
        console.log("Connected to MySQL server");
        con.destroy()
    });

}