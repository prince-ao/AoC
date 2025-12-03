const std = @import("std");
const math = std.math;
const print = std.debug.print;
const data = @embedFile("day2.txt");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var part1: u64 = 0;
    var part2: u64 = 0;

    var ranges = std.mem.tokenizeAny(u8, data, ",");

    while (ranges.next()) |range| {
        const counts = try count_invalid(range);
        part1 += counts[0];
        part2 += counts[1];
    }

    print("part 1 = sum of invalid ranges = {d}\n", .{part1});
    print("part 2 = sum of invalid ranges = {d}\n", .{part2});
}

fn count_invalid(range: []const u8) ![2]u64 {
    var start: u64 = 0;
    var end: u64 = 0;
    var i: u64 = 0;
    var part1: u64 = 0;
    var part2: u64 = 0;

    while (range[i] != '-') : (i += 1) {
        start = start * 10 + (range[i] - '0');
    }

    i += 1;

    while (i < range.len and range[i] != 10) : (i += 1) {
        end = end * 10 + (range[i] - '0');
    }

    i = start;

    while (i <= end) : (i += 1) {
        if (part1_is_invalid(i)) {
            part1 += i;
        }

        if (try part2_is_invalid(i)) {
            part2 += i;
        }
    }

    return .{ part1, part2 };
}

fn part2_is_invalid(id: u64) !bool {
    const digits: u64 = math.log10(id) + 1;
    return switch (digits) {
        1 => false,
        2 => @mod(id, 11) == 0,
        else => try check_sliding_window(id, digits),
    };
}

fn part1_is_invalid(id: u64) bool {
    const digits: u64 = math.log10(id) + 1;
    return switch (digits) {
        1 => false,
        2 => @mod(id, 11) == 0,
        else => check_split(id, digits),
    };
}

fn check_split(id: u64, digits: u64) bool {
    if (@mod(digits, 2) != 0) return false;

    const magnitiude = math.pow(u64, 10, digits / 2);

    const p1 = id / magnitiude;
    const p2 = id % magnitiude;

    return p1 == p2;
}

fn check_sliding_window(id: u64, digits: u64) !bool {
    const single_filter: u64 = (math.pow(u64, 10, digits) - 1) / 9;
    var window_size: u64 = 2;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var set = std.AutoHashMap(u64, void).init(allocator);
    defer set.deinit();

    if (@mod(id, single_filter) == 0) return true;

    while (window_size <= digits / 2) : (window_size += 1) {
        if (@mod(digits, window_size) != 0) continue;

        var i: u16 = 0;

        set.clearAndFree();

        while (i < digits / window_size) : (i += 1) {
            var current_value: u64 = 0;
            if (@mod(digits, 2) == 0) {
                current_value = (id / math.pow(u64, 10, digits - window_size - i * window_size)) % math.pow(u64, 10, window_size);
            } else {
                current_value = (id / math.pow(u64, 10, digits - window_size - i * window_size)) % math.pow(u64, 10, window_size);
            }

            if (set.count() == 0) {
                try set.put(current_value, {});
            }

            if (!set.contains(current_value)) break;
        }

        if (i == digits / window_size) return true;
    }

    return false;
}
