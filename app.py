from flask import Flask, request, jsonify
import yfinance as yf
from pandas import *
#from flask_mysqldb import MySQL
from flask_cors import CORS

app = Flask(__name__)
cors = CORS(app)
 
 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'Stocks'
#mysql = MySQL(app)

@app.route("/quote")
def display_quote():
	symbol = request.args.get('symbol', default="AAPL")

	stock_info = yf.Ticker(symbol).info
	
	return stock_info

@app.route("/history")
def display_history():
	symbol = request.args.get('symbol', default="AAPL")
	period = request.args.get('period', default="1y")
	interval = request.args.get('interval', default="1h")

	quote = yf.Ticker(symbol)	
	#cursor = mysql.connection.cursor()
	# cursor.execute(''' INSERT INTO StockInfo VALUES(%s,%s,%s)''',(quote.info["shortName"], quote.info["symbol"], quote.info["ask"]))
	# mysql.connection.commit()
	# cursor.close()

	hist = quote.history(period=period, interval=interval)
	data = hist.to_json()
	
	return data


if __name__ == "__main__":
	app.run(host="127.0.0.1", port=8000, debug=True)

