README.TXT

This is the README.TXT file for the data import process of the GZH News Recommendation System.
The process will:
	1. Convert the csv/json files into the proper encoding (UTF-8).
	2. Import them to "_raw" tables using pgfutter.
	3. Execute SQL scripts to clean and transform the data into its final form.

To load the data into the PostgreSQL database do the following:
	1. Assure the following files exist:
		Scripts:
			1_load_nohup.sh
			2_load.sh
			3_transform_nohup.sh
			4_transform.sh
			5_load_pushes_nohup.sh
			6_load_pushes.sh
			transform.sql
                        pushes.sql
		Binary:
			pgfutter
		
		Data:
			events.csv
			classifications.csv
			newsletter_optins.csv
			articles.json
	2. Execute ONLY THE ODD SCRIPTS in the given order. Attention!! Attention!! Attention!!
		Wait for the previous to finish before executing the next.
		The "_nohup.sh" scripts, while returning immediately to the command line, will keep running.
		You must wait until they are finish.
