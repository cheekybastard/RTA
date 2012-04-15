
HEIGHTS = { 'overlay': 500 , 'top': 100, 'bottom': 100, 'margin': 10 }
OV_HEIGHT = HEIGHTS['overlay']
PS_HEIGHT = HEIGHTS['top']
MARGIN = HEIGHTS['margin']

class StockChart
  constructor: (@el, @title, options) ->
    $(@el).css({ 'min-height': '600px'})
    
    @options = options || {}
    
    @items = 
      'overlay': []
      'top': [],
      'bottom': []
    
    @handle = new Highcharts.StockChart
      chart:
        alignTicks : false
        renderTo : @el
      title:
        text: @title
      rangeSelector: @rangeSelector()
      navigator: 
        enabled: true
      series: options.series || []
      yAxis: [ {  
        title:
          text: 'OHLC'
        height: 300
        }, {
        title:
          text: 'Volume'
        height: 100
        top: 400
        offset: 0,
        }]
      
  addSeries: (name, series, options) =>
    position = options['position' ] || 'overlay'
    @items[position].push(name)
        
    ss = @handle.addSeries
      name: name,
      data: series
      type: options['type']
      yAxis: options['yAxis'] || 0
      
      
          
    ss.position = position
    
    if options['redraw']
      @handle.redraw()
      
    @
    
  dateRange: =>
	  @handle.xAxis[0].getExtremes()
  
  rangeSelector: =>
  	buttons : [
  	  { type : 'day', count : 1, text : '1D'}, 
  	  { type : 'week', count : 1, text : '7D'}, 
      { type : 'all', count : 1, text : 'All' } ],
		selected : 1,
		inputEnabled : false
	
	  
	
class ChartView extends Backbone.View
  className: 'chart'
  
  render: =>
    url = [ api.url, 'api/quotes',  @model.get('id') + '.json?' ].join('/')
    
    
    $.getJSON url + '&callback=?', (data) =>
    		 @stockchart = new StockChart @el, @model.get('id'),
    		  series: [{
    		    name: 'OHLV', 
    		    data: data.records, 
    		    type : 'candlestick',
  		      }, {
  		      name: 'Volume', 
  		      data: data.volume
    		    type : 'column'
    		    yAxis: 1 }]
    		    
    		 app.models.chart = @stockchart
    		 
    @
  

module.exports = ChartView