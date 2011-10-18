var db = undefined;

function createOpenDatabase() {
    db = openDatabaseSync("BollywoodMovieDatabase", "1.0", "The Movie Database!", 1000000);
    db.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS IQ(key TEXT PRIMARY KEY, data FLOAT)');
                }
                )

}

function addData(movieIQ) {
    if (db === undefined)
        return;

    db.transaction(
                function(tx) {
                    tx.executeSql('REPLACE INTO IQ (key, data) VALUES(?, ?)', [ 'iq', movieIQ ])
                }
                )
}

function getData() {
    if (db === undefined)
        return;

    db.transaction(
                function(tx) {
                    var data = tx.executeSql('SELECT data FROM IQ WHERE key=?', ['iq']);
                    if (data.rows.length)
                        mainView.movieIQ = data.rows.item(0).data;
                    else
                        mainView.movieIQ = 100;
                    mainWindow.movieIQUpdated();
                }
                )
}

function initializeDatabase() {
    createOpenDatabase();
    getData();
    checkMovieDatabaseModelStatus();
}

function checkMovieDatabaseModelStatus() {
    if (movieDatabaseModel.status == XmlListModel.Ready) {
        statusBarPlayStatus.play = true;
    } else {
        xmlListModelTimer.restart();
    }
}

function selectMovieFromDatabaseModel() {
    var randomnumber = Math.floor(Math.random()*movieDatabaseModel.count);
    mainView.movieName = movieDatabaseModel.get(randomnumber).name.toUpperCase();
    mainView.movieActors = movieDatabaseModel.get(randomnumber).actor;
    mainView.movieDirector = movieDatabaseModel.get(randomnumber).director;
    mainView.movieMusicDirector = movieDatabaseModel.get(randomnumber).musicDirector;
    var movieName = mainView.movieName.replace(/\s/g, "  ");
    mainView.movieInputText = movieName.replace(/([a-z]|[0-9])/ig, "_ ");
    mainView.inputBlockState = true;
    mainView.hangmanBlockState = 0;
    mainView.actorBlockState = false;
    mainView.directorBlockState = false;
    mainView.musicDirectorBlockState = false;
}

function userInput(input) {
    //check if input is correct
    var success = false;
    var start = 0;
    var index = -1;
    input = input + "";
    input = input.toUpperCase();
    if (mainView.movieInputText.indexOf(input) == -1
            && mainView.missedCharacters.indexOf(input) == -1) {
        while ((index = mainView.movieName.indexOf(input, start)) != -1) {
            var temp = mainView.movieInputText.slice(0, index*2);
            temp += input;
            temp += mainView.movieInputText.slice(index*2 + 1);
            mainView.movieInputText = temp;
            start = index + 1;
            success = true;
        }
        if (!success) {
            mainView.hangmanBlockState++;
            mainView.missedCharacters += input + ", "
        }
    }

    //check for completion
    if (mainView.movieInputText.indexOf("_") == -1) {
        switch (mainView.hangmanBlockState) {
        case 0:
            mainView.movieIQ += 4.5;
            break;
        case 1:
            mainView.movieIQ += 4.0;
            break;
        case 2:
            mainView.movieIQ += 3.5;
            break;
        case 3:
            mainView.movieIQ += 3.2;
            break;
        default:
            break;
        }

        //score brownie points
        if (mainView.actorBlockState === 0)
            mainView.movieIQ += 1.5;

        if (mainView.directorBlockState === 0)
            mainView.movieIQ += 1.5

        if (mainView.movieDirectorBlockState === 0)
            mainView.movieIQ += 1.5

        mainView.inputBlockState = 0;
        statusBarPlayStatus.play = true;
        mainView.missedCharacters = "Great! You have Won!!"
    }

    if (mainView.hangmanBlockState == 4) {
        mainView.movieIQ -= 3.0;
        mainView.inputBlockState = 0;
        statusBarPlayStatus.play = true;
        mainView.movieInputText = mainView.movieName.replace(/\s/g, "  ");
        mainView.missedCharacters = "Sorry! You have Lost!!"
    }

    mainWindow.movieIQUpdated();
    return success;
}

function hintClicked() {
    if (mainView.movieInputText.indexOf("_") != -1) {
        mainView.movieIQ -= 1.5;
        mainWindow.movieIQUpdated();
    }
}
