# MEMMan

A virtual memory manager built in Ruby

## Usage

```ruby
# Reserving an initial block of memory
mm = MemMan.reserve_block(5)

# Allocating blocks of memory
b1 = mm.alloc(1)

# Reading and Writing to virtual memory
b1.write('a')
b1.read        # => "a"

# Multiple bytes may be written at once given enough space is allocated
b1 = mm.alloc(2)
b1.write('ab')
b1.read        # => "ab"

# Freeing virtual Memory
mm.free(b1)

```

## Technical Theory

1. `Blocks` are the operating object.  They represent a writable, readable, allocatable block of memory.
2. An array of `Byte` objects represents individual memory locations.  Each Byte has a value and a parent (the `MemMan::Block` it was allocated from).  Blocks maintain this array through writes and reads.
3. The `MemMan` module method `reserve_block` is mostly a wrapping for creating a new Block at the moment, but there could be special considerations for the initial block allocation that would live here.
4. Defragmentation of memory is not handled because we build Block arrays from individual unallocated elements of the parent byte array.

## Known Issues
- Freeing currently does not "nil" the memory at that location which means memory locations are not accurately freed as expected
- This implementation is a little over-ambitious because it also supports partially allocating further blocks from allocated blocks.  This is a pattern used in high performance systems so that each major subsystem can pre-allocate large blocks of memory at initialization time.

## Future Improvements
- Improved handling of sub-block writting, currently actual values are not propoageted to the parent block representation
- Better test coverage for edge cases (i.e. Deep recurive allocation validation, value propogation, etc.

