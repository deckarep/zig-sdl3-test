const std = @import("std");
const c = @import("cdefs.zig").c;
const shim = @import("sdlshim.zig");

const SW = 1024;
const SH = 768;

pub var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const gAllocator = gpa.allocator();

const AppError = shim.Error || std.mem.Allocator.Error;

const App = struct {
    win: ?*c.SDL_Window,
    renderer: ?*c.SDL_Renderer,
};

fn assertTrue(result: bool) void {
    std.debug.assert(result);
}

fn doQuit(win: ?*c.SDL_Window) void {
    if (win) |w| {
        const msgBoxRes = c.SDL_ShowSimpleMessageBox(
            c.SDL_MESSAGEBOX_INFORMATION,
            "Quitting...",
            "User requested to quit, so quitting!",
            @as(?*c.SDL_Window, @alignCast(@ptrCast(w))),
        );
        assertTrue(msgBoxRes);
    }
}

pub fn main() !void {
    sdlMain() catch |err| switch (err) {
        error.Invocation => {
            std.log.debug("Invocation error occurred, inspecting SDL Error state...", .{});
        },
        else => @panic("Unhandled error!"),
    };
}

pub fn sdlMain() AppError!void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    defer shim.Quit();
    try shim.Init(c.SDL_INIT_AUDIO | c.SDL_INIT_VIDEO | c.SDL_INIT_EVENTS);

    const app = try gAllocator.create(App);
    defer gAllocator.destroy(app);

    try shim.CreateWindowAndRenderer(
        "Hello World",
        SW,
        SH,
        c.SDL_WINDOW_OPENGL | c.SDL_WINDOW_RESIZABLE,
        &app.win,
        &app.renderer,
    );

    defer shim.DestroyWindow(app.win);

    mainloop: while (true) {
        var e: c.SDL_Event = undefined;
        while (shim.PollEvent(&e)) {
            if (e.type == c.SDL_EVENT_QUIT) {
                doQuit(app.win);
                break :mainloop;
            } else if (e.type == c.SDL_EVENT_KEY_DOWN) {
                if (e.key.scancode == c.SDL_SCANCODE_ESCAPE) {
                    doQuit(app.win);
                    break :mainloop;
                }
            }
        }

        try shim.SetRenderDrawColor(app.renderer, 0, 0, 0, c.SDL_ALPHA_OPAQUE);
        try shim.RenderClear(app.renderer);
        try shim.SetRenderDrawColor(app.renderer, 255, 255, 255, c.SDL_ALPHA_OPAQUE);

        const r: c.SDL_FRect = .{
            .x = c.SDL_randf() * SW,
            .y = c.SDL_randf() * SH,
            .w = 5,
            .h = 5,
        };

        try shim.RenderFillRect(app.renderer, &r);
        try shim.RenderPresent(app.renderer);
    }
}
