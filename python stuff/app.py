from flask import Flask, request, jsonify
import yfinance as yf
from pandas import *
from flask_mysqldb import MySQL
from flask_cors import CORS

import time as T

app = Flask(__name__)
cors = CORS(app)
 
 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'Stocks'
mysql = MySQL(app)

# @app.route("/info")
# def display_info():
# 	symbol = request.args.get('symbol', default="AAPL")
	

# 	return jsonify({"name": stock_name})

@ app.route("/updateAllHistory")
def get_all_history():
	try:
		df = read_csv("nasdaq.csv", keep_default_na=False)
		tickers = df["Symbol"].tolist()
		names = df["Name"].tolist()
		
		cursor = MySQL.cursor()
		start = T.time()
		for i in range(len(tickers)):
			print("Getting history for: " + tickers[i] + " - " + names[i])
			quote = yf.Ticker(str(tickers[i]))
			history = quote.history(period="5y", interval="1d")
			if not history["Close"].empty:
				open_dict = history["Open"].to_dict()
				close_dict = history["Close"].to_dict()
				high_dict = history["High"].to_dict()
				low_dict = history["Low"].to_dict()
				volume_dict = history["Volume"].to_dict()
				for time,open in open_dict.items():
					close = close_dict[time]
					high = high_dict[time]
					low = low_dict[time]
					volume = volume_dict[time]
					try:
						cursor.execute(''' INSERT IGNORE INTO stock_prices(symbol,date,open,close,high,low,volume) VALUES(%s,%s,%s,%s,%s,%s,%s)''',(tickers[i], time, open, close, high, low, volume))
					except mysql.connector.Error as err:
						print("MySQL error: {}".format(err))
					print("Inserted: " + tickers[i] + " at " + str(time))
					cursor.commit()
		end = T.time()
		print("Time taken: " + str(end-start))
		cursor.commit()
		cursor.close()
	except Exception as e:
		return str(e)
	return "Done"



@ app.route("/quote")
def display_quote():
	symbol = request.args.get('symbol', default="AAPL")
	ticker = yf.Ticker(symbol)
	stock_last_price = ticker.fast_info.get("lastPrice")
	return jsonify({"lastPrice": stock_last_price})

@app.route("/history")
def display_history():
	symbol = request.args.get('symbol', default="AAPL")
	period = request.args.get('period', default="1y")
	interval = request.args.get('interval', default="1d")

	quote = yf.Ticker(symbol)	


	hist = quote.history(period=period, interval=interval)
		
	data = hist.to_json()
	
	return data


if __name__ == "__main__":
	app.run(host="127.0.0.1", port=8000, debug=True)

