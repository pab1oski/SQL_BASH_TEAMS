#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE games,teams")"

# Insert in games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
# Avoid the case of redinf the title
if [[ $YEAR != 'year' ]]
then
  # get the winner and the opponet id based on the name
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"

  # See if THE winner is  null
  if [[ -z $WINNER_ID ]]
  then
    #If it returns null , create an entry of boths
    INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"

    if [[ $INSERT_WINNER = "INSERT 0 1" ]]
    then
      echo "Team inserted , $WINNER"
    fi

    # get the winner id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
  fi

  # See if THE OPPONENT is  null
  if [[ -z $OPPONENT_ID ]]
  then
    # If it returns null , create an entry of boths
      INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"

    if [[ $INSERT_OPPONENT = "INSERT 0 1" ]]
    then
      echo "Team inserted , $OPPONENT"
    fi

    # get the winner id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
  fi

  # Insert the query complete
  INSERT_DATA="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID',$W_GOALS,$O_GOALS)")"

fi
done
