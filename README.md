# Statusboard

The statusboard gem provides a **simple, expressive DSL** which can be used to feed your Panic-powered Status Board with custom data. The DSL handles table, graph and DIY widgets in a way that renders messing around with the raw data unnecessary.

The included server module makes serving the data to the app a really straight-forward process that doesn't require any server-related code at all. The Rack-compliance of the server module makes the integration with existing systems a breeze.

[Visit the Panic website for more information about the Status Board app.](https://panic.com/statusboard/)

## Getting Started

### Installation
Install the gem by either running `gem install statusboard` or by adding the line `gem "statusboard"` to your Gemfile and running the `bundle` command.

### Your first Status Board data source:

Create a file called statusboard.rb with the following contents:

```ruby
require "statusboard/main"

widget "yequalsx", :graph do
	title "My first graph"
	type :line

	data do
		data_sequence do
			title "f(x) = x"

			(0..15).each do |n|
				datapoint n, n
			end
		end
	end
end
```

and run `ruby statusboard.rb`. A webserver that serves the widget will automatically be started on port 8080. In your Status Board App, add a graph widget and set the URL to `your.ip:8080/widget/yequalsx`. The app should now display the graph.

For further and more complex examples take a look at the `examples` directory.

## DSL
The statusboard gem makes use of a simple, expressive DSL which is used to configure and feed the widgets. The statements of the DSL are explained in the following paragraph.

### widget
The **widget** statement is used to define a new widget with a specified _name_ and _type_. The widgets name is used as the identifier of the widget and hence has to be unique. A block must be specified with further DSL statements which describe the widget and its contents.

```ruby
widget name, type do
	...
end
```

Supported types are `:table`, `:diy` and `:graph`. The specified type directly translates to the corresponding class, e.g. `:table` will use the class `Statusboard::TableWidget`.

Example:
```ruby
widget :sales, :graph do
	...
end
```
The above code will define a graph-widget with the name `sales`. The widget will be available at the URL `http://your.ip:8080/widget/sales/`.

#### Advanced Features
 - Custom widget types are supported: Create a subclass of `Statusboard::WidgetBase` in the `Statusboard` module with a name like `MycustomWidget` (replace `Mycustom`). Then use the corresponding identifier (e.g. `:mycustom`) with the widget statement.
 - You can create a widget manually (by instanciating the widgets class) and pass the resulting object directly to the widget statement as the second parameter. In this case, the block must not be specified.

```ruby
my_diy = Statusboard::DiyWidget.new do
	...
end

widget :mycustom1, my_diy
```

### Table widget

## Advanced Usage

The gem can be used in _three_ different ways:

### **Standalone**
In this scenario, the gem is used to create a standalone server application whose only purpose is to serve data to the Status Board app. As this is the prevalent case, the gem was designed to support this scenario without having to write any code other than the code that acts as the data source.

If this scenario fits your needs best, just add the line

```ruby
require "statusboard/main"
```

to the top of your application file and define the widgets you want your Status Board to display using the DSL:

```ruby
widget "widget-name", :widget-type do
	... use the DSL to describe the widget here
end
```

Run the file and a server is started automatically.

### As a module within an existing Rack-based app
In this scenario, the gem is used within an existing, Rack-based server application. The included Rack module is mounted in the application (e.g. using the routes.rb file of a rails app).

To create a server instance which can be used in a Rack-based environment, include the required files by adding the line

```ruby
require "statusboard/server"
```
to your application file.

Afterwards create the server instance and use its constructors block to describe the widgets which should be served:

```ruby
app = Statusboard::StatusboardServer.new do
	widget ... do
    	...
    end
end
```

Use `app` as a parameter to the mount call to integrate the Status Board serving with your existing app.

### Without a server
The gem can be used to describe a widget and construct the Status Board compatible ouput without using any of its server components. This allows for an easy integration into existing applications like non-Rack-based web servers or the generation of data which is used and/or served statically later on.

To use _only_ the data construction capabilities of the statusboard gem, add the following line to your application file:

```ruby
require "statusboard"
```

Afterwards you can instanciate the classes `Statusboard::DiyWidget`, `Statusboard::GraphWidget` or `Statusboard::TableWidget` by passing a block containing the DSL statements to the constructor. Call the `render` method on a newly created object to retrieve the Status Board compatible output:

```ruby
my_widget = Statusboard::DiyWidget.new do
	content "My first widget with custom content!"
end

puts my_widget.render
```

## Contributing

1. Fork it ( https://github.com/JulezJulian/statusboard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
