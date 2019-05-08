# auto_cleaner

Auto::Cleaner class takes responsibility for removing temporary files, directories and running custom cleaning procedures on exit

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     auto_cleaner:
       github: DRVTiny/auto_cleaner
   ```

2. Run `shards install`

## Usage

```crystal
require "auto_cleaner"
ac = Auto::Cleaner.new
ac.add_file( File.tempfile("prefix", ".tmp").path )
send_message_to = {host: "myserver.example.com", account: "somebody@example.com"}
ac.add_proc(send_message_to) do |useful_info|
	puts "Cleaning in progress"
	puts "After all we need to send message about cleaning status to..."
	pp useful_info
	1
end

# you can call this method directly, but it will be called
# automagically on application exit
# if you call this method explicitly, then all lists of objects to be
# cleaned on exit will be emptied

ac.make_mrproper
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/DRVTiny/auto_cleaner/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Andrey A. Konovalov](https://github.com/DRVTiny) - creator and maintainer
