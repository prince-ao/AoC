const std = @import("std");
const data = @embedFile("day1.txt");

pub fn main() !void {
    var dial: i16 = 50;
    var part1: u32 = 0;
    var part2: u32 = 0;
    const ROTATE_END: i16 = 99;

    var lines = std.mem.tokenizeAny(u8, data, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var rotate_value: i16 = 0;
        var i: u8 = 1;

        while (i < line.len) : (i += 1) {
            rotate_value = rotate_value * 10 + (line[i] - '0');
        }

        part2 += @intCast(@divTrunc(rotate_value, ROTATE_END + 1));

        rotate_value = @mod(rotate_value, ROTATE_END + 1);

        if (line[0] == 'L') rotate_value *= -1;

        const old_dial = dial;

        dial += rotate_value;

        if (old_dial == 0) part1 += 1;
        if (dial <= 0 and old_dial != 0) part2 += 1;
        if (dial < 0) dial += 100;
        if (dial >= 100) {
            part2 += 1;
            dial -= 100;
        }
    }

    std.debug.print("part 1 actual password = {d}\n", .{part1});
    std.debug.print("part 2 actual password = {d}\n", .{part2});
}
