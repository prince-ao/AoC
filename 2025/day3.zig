const std = @import("std");
const data = @embedFile("day3.txt");
const print = std.debug.print;
const math = std.math;

const Element = struct {
    value: u8,
    index: u64,
};

fn compareElements(context: void, a: Element, b: Element) math.Order {
    _ = context;
    if (a.value < b.value) {
        return math.Order.lt;
    } else if (a.value > b.value) {
        return math.Order.gt;
    } else {
        return math.Order.eq;
    }
}

pub fn main() !void {
    var banks = std.mem.tokenizeAny(u8, data, "\n");
    var part1_max: [2]u8 = .{ '0', '0' };
    var part1: u64 = 0;
    var part2: u64 = 0;
    var part2_s: [12]u8 = .{0} ** 12;

    while (banks.next()) |bank| {
        for (bank, 0..) |joltage, i| {
            if (joltage > part1_max[0]) {
                if (i == bank.len - 1) {
                    part1_max[1] = joltage;
                    break;
                }
                part1_max[0] = joltage;
                part1_max[1] = '0';
            } else if (joltage > part1_max[1]) {
                part1_max[1] = joltage;
            }
        }

        fill_max(part2_s[0..], bank[0..], 12);

        part1 += try std.fmt.parseInt(u32, part1_max[0..], 10);

        print("part 2 s = {s}\n", .{part2_s});
        part2 += try std.fmt.parseInt(u64, part2_s[0..], 10);

        part1_max[0] = '0';
        part1_max[1] = '0';
    }

    print("part 1 max joltage = {d}\npart 2 max joltage = {d}", .{ part1, part2 });
}

fn fill_max(store: []u8, bank: []const u8, depth: usize) void {
    if (depth == 0) return;

    var max: u8 = '0';
    var max_i: u64 = 0;
    for (bank, 0..) |joltage, i| {
        if (i == bank.len - depth + 1) break;
        if (joltage > max) {
            max = joltage;
            max_i = i;
        }
    }

    store[12 - depth] = max;

    fill_max(store, bank[max_i + 1 ..], depth - 1);
}
