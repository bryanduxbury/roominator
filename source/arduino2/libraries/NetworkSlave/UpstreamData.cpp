#include <UpstreamData.h>

void UpstreamData::setReserve(int value) {
  reserve = value;
}

int UpstreamData::getReserve() {
  return reserve;
}

void UpstreamData::setCancel(bool value) {
  cancel = value;
}

bool UpstreamData::getCancel() {
  return cancel;
}
