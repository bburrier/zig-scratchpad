const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;


pub fn range(len: usize) []const u0 {
    return @as([*]u0, undefined)[0..len];
}

pub fn main() anyerror!void {
    // The number of values to compute
    var n: usize = undefined;

    // Create allocator and results ArrayList
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var results = ArrayList(u128).init(allocator);
    defer results.deinit();

    // Read command line arguments
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    _ = args.next(); // Skip the first argument (program name)
    const count = args.next();

    // Parse the count argument
    if(count) |value| {
        std.debug.print("Fibonacci sequence, {s} values:\n", .{value});
        n = try std.fmt.parseUnsigned(usize, value, 10);
    }
    else {
        std.debug.print("Usage: fib <count>\n", .{});
        return;
    }

    // Compute the Fibonacci sequence to the nth value
    for (range(n)) |_, i| {
        // First value
        if(i == 0) {
            try results.append(0);
            continue;
        }

        // Second value
        if(i == 1) {
            try results.append(1);
            continue;
        }

        // Third value and above
        var value = results.items[i-1] + results.items[i-2];
        try results.append(value);
    }

    // Print results
    for(results.toOwnedSlice()) |value| {
        std.debug.print("{}\n", .{value});
    }
}
