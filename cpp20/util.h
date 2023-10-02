// Copyright 2021 Zipline International Inc. All rights reserved.

#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace zipline
{
using Timestamp = int32_t;

std::vector<std::string> ParseInputLine(const std::string &line);
}  // namespace zipline
