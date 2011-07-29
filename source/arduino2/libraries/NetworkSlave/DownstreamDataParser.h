#ifndef DownstreamDataParser_h
#define DownstreamDataParser_h

#include "DownstreamData.h"

class DownstreamDataParser {
  public:
    static void parseAndUpdateDownstreamData(char *received, DownstreamData* dd);
};

#endif
