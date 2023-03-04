module.exports = [
    ["class std.mutex", "", [], [], "", ""],
    ["std.mutex.mutex", "", [], [], "", ""],
    ["std.mutex.lock", "void", [], [], "", ""],
    ["std.mutex.try_lock", "bool", [], [], "", ""],
    ["std.mutex.unlock", "void", [], [], "", ""],

    ["class std.timed_mutex", "", [], [], "", ""],
    ["std.timed_mutex.timed_mutex", "", [], [], "", ""],
    ["std.timed_mutex.lock", "void", [], [], "", ""],
    ["std.timed_mutex.try_lock", "bool", [], [], "", ""],
    ["std.timed_mutex.try_lock_for", "bool", [], [
        ["int", "duration", "", ["/Cast=std::chrono::milliseconds"]],
    ], "", ""],
    ["std.timed_mutex.unlock", "void", [], [], "", ""],
];
