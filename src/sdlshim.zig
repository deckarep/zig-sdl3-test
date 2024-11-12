const std = @import("std");
const c = @import("cdefs.zig").c;

const sdlOf = 3;

pub const Error = error{Invocation};

pub inline fn CreateWindowAndRenderer(
    title: [*:0]const u8,
    width: c_int,
    height: c_int,
    window_flags: c.SDL_WindowFlags,
    window: *?*c.SDL_Window,
    renderer: *?*c.SDL_Renderer,
) Error!void {
    if (sdlOf == 3) {
        if (!c.SDL_CreateWindowAndRenderer(title, width, height, window_flags, window, renderer)) {
            std.log.err("Failed to CreateWindowAndRenderer", .{});
            return Error.Invocation;
        }
        // _ = title;
        // _ = width;
        // _ = height;
        // _ = window_flags;
        // _ = window;
        // _ = renderer;
        // return Error.Invocation;
    } else {
        // todo: sdl2
    }
}

pub inline fn DestroyWindow(win: ?*c.SDL_Window) void {
    if (sdlOf == 3) {
        c.SDL_DestroyWindow(win);
    } else {
        // todo: sdl2
    }
}

pub inline fn Init(flags: c.SDL_InitFlags) Error!void {
    if (sdlOf == 3) {
        if (!c.SDL_Init(flags)) {
            return Error.Invocation;
        }
    } else {
        // todo: sdl2
    }
}

pub inline fn PollEvent(event: *c.SDL_Event) bool {
    if (sdlOf == 3) {
        return c.SDL_PollEvent(event);
    } else {
        // todo: sdl2
        return false;
    }
}

pub inline fn RenderFillRect(renderer: ?*c.SDL_Renderer, r: *const c.SDL_FRect) Error!void {
    if (sdlOf == 3) {
        if (!c.SDL_RenderFillRect(renderer, r)) {
            return Error.Invocation;
        }
    } else {
        // todo: sdl2
    }
}

pub inline fn RenderClear(renderer: ?*c.SDL_Renderer) Error!void {
    if (sdlOf == 3) {
        if (!c.SDL_RenderClear(renderer)) {
            return Error.Invocation;
        }
    } else {
        // todo: sdl2
    }
}

pub inline fn RenderPresent(renderer: ?*c.SDL_Renderer) Error!void {
    if (sdlOf == 3) {
        if (!c.SDL_RenderPresent(renderer)) {
            return Error.Invocation;
        }
    } else {
        // todo: sdl2
    }
}

pub inline fn SetRenderDrawColor(renderer: ?*c.SDL_Renderer, r: u8, g: u8, b: u8, a: u8) Error!void {
    if (sdlOf == 3) {
        if (!c.SDL_SetRenderDrawColor(renderer, r, g, b, a)) {
            return Error.Invocation;
        }
    } else {
        // todo: sdl2
    }
}

pub inline fn Quit() void {
    if (sdlOf == 3) {
        c.SDL_Quit();
    } else {
        // todo: sdl2
    }
}
