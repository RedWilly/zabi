const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("contract_example", .{ .root_source_file = .{ .path = "contract.zig" } });

    const exe = b.addExecutable(.{
        .name = "contract_example",
        .root_source_file = .{ .path = "contract.zig" },
        .target = target,
        .optimize = optimize,
    });

    addDependencies(b, exe);
    b.installArtifact(exe);
}

fn addDependencies(b: *std.Build, step: *std.Build.Step.Compile) void {
    const target = step.root_module.resolved_target.?;
    const optimize = step.root_module.optimize.?;

    const zabi = b.dependency("zabi", .{
        .target = target,
        .optimize = optimize,
    });

    step.root_module.addImport("zabi", zabi.module("zabi"));
}
