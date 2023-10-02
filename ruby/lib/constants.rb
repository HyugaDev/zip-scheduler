module Constants
  # Each Nest has this many Zips
  NUM_ZIPS = 10

  # Each Zip can carry between 1 and this many packages per flight
  # Note: a Zip can deliver more than 1 package per stop
  MAX_PACKAGES_PER_ZIP = 3

  # Zips fly a constant groundspeed (m/s)
  ZIP_SPEED_MPS = 30

  # Zips can fly a total roundtrip distance (m)
  ZIP_MAX_CUMULATIVE_RANGE_M = 160 * 1000 # 160 km -> meters

  # The two acceptable priorities
  EMERGENCY = :emergency
  RESUPPLY = :resupply

  SEC_PER_DAY = 24 * 60 * 60
end
