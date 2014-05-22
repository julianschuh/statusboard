# Statusboard

The statusboard gem provides a **simple, expressive DSL** which was purpose-built to feed your Panic-powered Status Board with custom static or dynamic data. The DSL handles table, graph and DIY widgets in a way that renders messing around with raw data unnecessary.

The included server module makes serving the data to the app a simple and straight-forward process that doesn't require you to write any server-related code. The Rack-compliance of the server module makes the integration with existing systems a breeze.

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

and run `ruby statusboard.rb`. A webserver which serves the widget will automatically be started on port 8080. In your Status Board App, add a graph widget and set the URL to `your.ip:8080/widget/yequalsx`. A graph widget containing the plot of the mathematical function `f(x) = x` will be displayed.

For further and more complex examples take a look at the `examples` directory.

## DSL
The statusboard gem features a simple and expressive DSL which is used to configure and feed the widgets with data. Supported statements of the DSL are explained in the following paragraphs.

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
A table widget provides one top-level statement: `data`, which accepts either a block or a proc. The specified block/proc should contain the code that fetches the data to be displayed. The block/proc will be executed every time the widget is requested from the app.
Within the block/proc, the DSL can be used to specify the data:

The `row` statement creates a new row. A block must be specified in which the cells of the row are specified. The only statement that is accepted within `row` is the `cell` statement.

The `cell` statement creates a cell within a row. A `cell` can have different properties as listed below:

| Statement 	| Description	|
| ------------- | ------------- |
| type 			| Type of the cell. (Sell table below for supported types)|
| content 		| Main content of the cell. Depends on the cell type.|
| width 		| Width of the cell. Can be specified in px or percent. |
| colspan		| Colspan of the cell |
| percentage 	| Percentage which should be displayed. Only used if cell type is `:percentage`|
| imageurl		| URL of the image that should be displayed. Only used if cell type is `:image`|
| noresize		| Indicates if the image should be resized or not. Only used if cell type is `:image`|

The following cell types are supported:

| Type 			| Description 	|
| ------------- | ------------- |
| `:text`		| Displays the text specified as `content` |
| `:percentage`	| Displays a percentage indicator. Percentage must be specified using the `percentage` statement |
| `:image`		| Displays an image. URL must be specified using the `imageurl` statement. |
| `:cutsom`		| Enables the use of custom cell. The cell (including all necessary HTML markup) must be specified using the `content` statement. |

Example:

```ruby
data_proc = Proc.new do
	row do
		cell do
			type :text
			content "First row with 20%"
		end

		cell do
			type :percentage
			percentage 20
		end
	end

	row do
		cell do
			type :text
			content "Second row with 80%"
		end

		cell do
			type :percentage
			percentage 80
		end
	end
end

widget :testtable do
	data data_proc
end
```

### Graph Widget

A graph widget provides seven top-level statements:

| Statement		| Description 	|
| ------------- | ------------- |
| `data`		| A block or proc which handles fetching of the data. |
| `x_axis`		| A block which can be used to configure the behavior of the X axis. |
| `y_axis`		| A block which can be used to configure the behavior of the Y axis. |
| `refresh_interval`	| Specifies how often the data should be refreshed by the app (in seconds). |
| `title`		| Specified the title of the widget. |
| `type`		| Specifies the type of the graph. Supported values: `:bar` and `:line` |
| `display_totals`	| Specified wether or not the totals of all data sequences should be displayed. Can be called without parameter. |


#### The `data` statement

The `data` statement is used to feed the graph widget with data. It provides exactly one statement:
`data_sequence`.
The statement defines a new data sequence, which is a collection of data points that belong together. The data points of a sequence taken together yield to the corresponding line in the graph.The statement can be called multiple times if multiple data sequences should be specified.

The `data_sequence` again takes a block which is used to configure the data sequence and to specify the data which should be displayed:

| Statement		| Description 	|
| ------------- | ------------- |
| `title`		| Title describing the data sequence. E.g. "Sales per Day" |
| `color`		| The color in which the line or bars should appear. |
| `datapoint`	| Adds a data point to the current data sequence. The statement accespts *two* parameters: The **X** coordinate and the **Y** coordinate. The statement can be called multiple times in order to add multiple data points. Data points will displayed in the order they are added, _not_ sorted by the X coordinate. |

#### The `x_axis` statement

The following statement(s) are supported to configure the behavior of the **X** axis.

| Statement		| Description 	|
| ------------- | ------------- |
| `show_every_label` | Forces every x datapoints to be displayed on the axis. Can be called without parameter. |

#### The `y_axis` statement

The following statement(s) are supported to configure the behavior of the **Y** axis.

| Statement		| Description 	|
| ------------- | ------------- |
| `min_value` | Minimum value of the Y coordinate of every datapoint which should be displayed. |
| `max_value` | Maximum value of the Y coordinate of every datapoint which should be displayed. |
| `units_suffix` | Suffix which is appended to the Y axis labels. Can be used to add a unit to the raw data. |
| `units_prefix` | Prefix which is prepended to the Y axis labels. Can be used to add a unit to the raw data. |
| `scale_to` | Scales the Y coordinates by the specified value. |
| `hide_labels` | Specified if no lebsl should be displayed at all for the Y axis. Can be called without parameter. |

#### Example

```ruby
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

### DIY Widget

The DIY widget allows to create completely custom-made, HTML-based widgets. As a further abstraction is not possible, the widgets offers only _one_ top-level statement: `content`. `content` awaits either a block, a proc or an arbitrary object which can be converted to a string.

Example:

```ruby
widget "custom", :diy do
	content do
		%w[this is a test].join(" ")
	end
end
```

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
