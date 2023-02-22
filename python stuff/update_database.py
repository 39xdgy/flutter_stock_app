import mysql.connector
from pandas import *
import yfinance as yf
import time as T

mydb = mysql.connector.connect(
  host = 'localhost',
  user = 'root',
  password = "",
  database = "Stocks"
)
def get_all_info():
	try:
		df = read_csv("nasdaq.csv", keep_default_na=False)
		tickers = df["Symbol"].tolist()
		names = df["Name"].tolist()
		
		cursor = mydb.cursor()
		start = T.time()
		for i in range(len(tickers)):
			print("Getting info for: " + tickers[i] + " - " + names[i])
			cursor.execute(''' INSERT IGNORE INTO stock_info(symbol,name) VALUES(%s,%s)''',(tickers[i], names[i]))
			mydb.commit()
			
		end = T.time()
		print("Time taken: " + str(end-start))
		mydb.commit()
		# cursor.close()
	except Exception as e:
		return str(e)
	return "Done"

def get_all_history():
	try:
		df = read_csv("nasdaq.csv", keep_default_na=False)
		tickers = df["Symbol"].tolist()
		names = df["Name"].tolist()
		
		cursor = mydb.cursor()
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
					#print("Inserted: " + tickers[i] + " at " + str(time))
					mydb.commit()
		end = T.time()
		print("Time taken: " + str(end-start))
		mydb.commit()
		# cursor.close()
	except Exception as e:
		return str(e)
	return "Done"

if __name__ == "__main__":
	get_all_info()
	get_all_history()
