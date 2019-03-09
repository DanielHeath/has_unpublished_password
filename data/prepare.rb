# Create a filter with 1024 (next power of 2) slots with each bucket holding 4
cf = CuckooFilter.make(size: 1000, kicks: 500, bucket_size: 4)
# => returns a CuckooFilter::CuckooFilter instance

# Insert an element into the filter
cf.insert("foo")
# => true

# Lookup the existence of an element
cf.lookup("foo")
# => true

cf.lookup("bar")
# => false

# Delete an existing element
cf.delete("foo")
# => true