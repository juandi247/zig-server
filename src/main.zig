const std = @import("std");
const zig_server = @import("zig_server");

pub fn main() !void {
    const c = std.c;
    const print = std.debug.print;
    //const addr = try std.Io.net.IpAddress.parseIp4("127.0.0.1",  "8090");

    //const addr  =  std.Io.net.IpAddress.parse("127.0.0.1", 8080) catch |err|{
    //   print("ERROR {}", .{err});
    //return;
    //} ;
    const fd: c_int = c.socket(c.AF.INET, c.SOCK.STREAM, c.SOCK.NONBLOCK);

    if (fd == -1) {
        print("creating socket error: {}", .{fd});
        return;
    }

    if (c.listen(fd, 23) != 0) {
        return;
    }

    var addr: c.sockaddr.in = undefined;

    addr.port = 8080;
    addr.addr = 0;

    var castedAddr: c.sockaddr = @ptrCast(addr);
    if (c.bind(fd, &castedAddr, @sizeOf(c.sockaddr.in)) != 0) |code| {
        print("error code: {}", .{code});
        return;
    }

    if (c.listen(fd, 10000) != 0) |code| {
        print("error code: {}", .{code});
        return;
    }

    if (c.epoll_create1(0) != 0) |code| {
        print("error code: {}", .{code});
        return;
    }

    //add here the accept socket right(??)
    //c.epoll_ctl(epfd: either type, op: c_uint, fd: either type, event: ?*either type)

    while (true) {
        const clientSockAddr: *const c.sockaddr = @ptrCast(c.sockaddr.in);
        const clientFd = c.accept4(fd, clientSockAddr, @sizeOf(c.sockaddr.in), c.SOCK.NONBLOCK);
    }
    // 1. abrir un socket (debe ser nonblocking (como se pone eso??? ni idea))
    // 2. crear un epoll, registrar el socket  epoll_create
    // 3. epoll_ctl para registrar
    // 4. Abrimos un for loop constante, en donde revisamos los valore suqe estan en epoll, epoll_wait
    // // 5. si es del tipoi de socket accept, revisar que haya algo y aceptar
    // 5.1 si es del tipo socket de conexion, etoncnes end, o leer,
    // 6. cerrar el socket de conexion siempre, y haberele scrito algo supongo

}
