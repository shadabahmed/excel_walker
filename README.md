# ExcelWalker

Excel Walker is a declarative Microsoft Excel file parser and generator. It uses [Axlsx](https://github.com/randym/axlsx) to write and [Creek](https://github.com/pythonicrubyist/creek) to read.

# Why I created this ?

While dealing with Excel files recently, I noticed that excel files are never a set of homogenous data, which you can iterate over directly. Rather there are regions of interest whether in the same worksheet or across worksheets, which you want to work upon differently. For e.g. look at the spreadsheet below:

![currency_excel](https://cloud.githubusercontent.com/assets/830679/2937625/d333658e-d8bf-11e3-9619-658e20c425a0.png)

We are not interested in the top header, we just want the country, currency and USD exchange rate so that we can store that in our database in currencies table. The regions are marked in RED. If you were to go interatively over each row, then lot of custom logic would have to fit in.

What if you could just declare this - Start from row 3 and just give me 1st, 2nd and 4th column. Let's see this in code:

````ruby

sheet.on_rows(3..60).pluck_columns([1, 2, 4]).run do |(country, currency_code, exchange_rate)|
  Currency.create(country: country, code: currency_code, rate: exchange_rate)
end

````

Similarly lets see how we can export the data from our database into an excel:

```ruby

currencies = Currency.all
sheet.on_rows(3..60).after_column(0).fill do |cells, row_index|
   currency = currencies[row_index]
   cells.data = [currency.name. currency.code, currency.rate]
end

```
You can also create headers and other information declaratively. I will add full running examples soon.

## Installation

Add this line to your application's Gemfile:

    gem 'excel_walker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install excel_walker

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
