#include "DownstreamData.h"

class Reservations {
  public:
    static DownstreamData* parseDownstreamData(byte *received);
};
