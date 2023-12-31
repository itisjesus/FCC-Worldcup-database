#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

# year, round, winner, opponent, winner_goals, opponent_goals
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    # WINNER TEAM
    # get winner team id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    # echo $TEAM_ID

    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner team name
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into team, $WINNER
      fi
      # get new winner team id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      # if not found it will go back to first if condition
    fi

    # OPPONENT TEAM
    # get team opponent id
    OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPPO_ID ]]
    then
      # insert opponent name
      INSERT_OPPO_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPO_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      # get new opponent team id
      OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      # if not found it will go back to first if condition
  
    fi

  fi

  # OPPONENT TEAM
  # get game id
  if [[ $YEAR != 'year' ]]
  then
    GAME_ID=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPO_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $GAME_ID == 'INSERT 0 1' ]]
    then
      echo Inserted winner team, $ROUND - $WINNER_ID
    fi
  fi

done
