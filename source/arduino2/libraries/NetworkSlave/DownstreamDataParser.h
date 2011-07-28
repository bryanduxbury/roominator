#ifndef DownstreamDataParser_h
#define DownstreamDataParser_h

#include "DownstreamData.h"

class DownstreamDataParser {
  public:
    static DownstreamData* parseDownstreamData(char *received);
};

#endif
