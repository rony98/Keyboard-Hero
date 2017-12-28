%Author: Vili Milner, Rony Verch, Ronen Zak
%File Name: Keyboard Hero.t
%Project Name: Keyboard Hero
%Creation Date: 21/05/2014
%Modified Date: 11/06/2014
%Description: The purpose of this is to recreate Guitar Hero.

%Setting up the window
const WINDOW : int := Window.Open ("graphics:700;700, position:center;center, nobuttonbar, offscreenonly") %Window

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DECLARING IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Note images
var note1 : int := Pic.FileNew ("Images/Note1.gif") %Green note
var note2 : int := Pic.FileNew ("Images/Note2.gif") %Red note
var note3 : int := Pic.FileNew ("Images/Note3.gif") %Yellow note
var note4 : int := Pic.FileNew ("Images/Note4.gif") %Blue note
var note5 : int := Pic.FileNew ("Images/Note5.gif") %Orange note
var note6 : int := Pic.FileNew ("Images/Note6.gif") %Light blye note (star power note)

%The 5 pictures where the user has to hit the note
var keyPressPic1 : int := Pic.FileNew ("Images/key1.gif") %Green key
var keyPressPic2 : int := Pic.FileNew ("Images/key2.gif") %Red key
var keyPressPic3 : int := Pic.FileNew ("Images/key3.gif") %Yellow key
var keyPressPic4 : int := Pic.FileNew ("Images/key4.gif") %Blue key
var keyPressPic5 : int := Pic.FileNew ("Images/key5.gif") %Orange key

%Setting up the main menu background picture
var mainBackgroundPic : int := Pic.FileNew ("Images/Keyboard Hero Background.jpg")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTANTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Number of columns and what notes to draw
const NUM_COLUMNS : int := 5 %Number of columns

%Max number of rows to draw
const ROW_DRAW_MAX : int := 20 %Maximum row to start drawing

%Maximum rows on screen at a time
const MAX_ROW_DRAW : int := 10 %Maximum rows to draw
const ROW_TIMER_MAX : int := 20 %Timer to determine when to add/get rid of notes

%Sizes of notes
const DIAMETER : int := 120 %Radius of the notes
const X_ADJUSTMENT : int := 60 %Absolute value to move X position
const Y_ADJUSTMENT : int := 700 %Absolute value to move Y position

%Delays the program to maintain a constant number of fps
const DELAY_PROGRAM : int := 16 %Delay to maintain constant FPS

%Constants for the five different columns that the notes can go in
const FIRST_COLUMN : int := 1 %First column
const SECOND_COLUMN : int := 2 %Second column
const THIRD_COLUMN : int := 3 %Third column
const FOURTH_COLUMN : int := 4 %Fourth column
const FIFTH_COLUMN : int := 5 %Fifth column

%Constants for if the notes were pressed on tiem and how well
const NOTE_HIT_PERFECT : int := 1 %Note pressed perfectly
const NOTE_HIT_GREAT : int := 2 %Note pressed well
const NOTE_HIT_OKAY : int := 3 %Note pressed okay
const NOTE_MISSED : int := 4 %Note missed
const NOTE_DONE : int := 5 %Note that the score was already added for
const NOTE_NEW : int := 6 %A new note

%Constants for the rock meter
const MAX_ROCK_METER : int := 100
const MIN_ROCK_METER : int := 0
const ROCK_METER_INCREMENT : int := 1

%Constant for the y value of the note key (where the user is soppused to click for the notes)
const NOTE_KEY_Y : int := 100

%Constant for half the size of where the key needs to be pressed
const NOTE_KEY_CENTER_Y : int := NOTE_KEY_Y + (Pic.Height (keyPressPic1) div 2)

%The timer which is used to make notes larger as they are coming towards the player
const RESIZE_TIMER_MAX : int := 10

%Constants for focus of the program
const MAIN_MENU : string := "mainmenu" %Focus is on the main menu
const PICK_SONG : string := "pick song" %Focus is on the pick song menu
const SONG_CREATOR : string := "song creator" %Focus is on the song creator menu
const GAME : string := "game" %Focus is on the game
const GAME_OVER : string := "game over" %Focus is on the game over menu
const INSTRUCTIONS : string := "instructions" %Focus is on the instructions
const SETTINGS : string := "settings" %Focus is the settings
const PROFILE : string := "profile" %Focus is the profile
const PICK_PROFILE : string := "Picking the profile" %Focus for when the user is loading a new profile
const NEW_PROFILE : string := "making a new profile" %Focus for making a new profile
const HIGHSCORES : string := "showing the high scores"  %Focus for showing the highscores page
const CHANGING_CONTROLS : string := "changing controls" %Focus is changing controls

%Width and heights of the tiles
const WIDTH_TILE : int := Pic.Width (note1) %Width of a tile
const HEIGHT_TILE : int := 80 %Height of a tile

%Constants that represent the note streak increasing or score
const NOTE_STREAK := 1 %Note streak increasing by 1
const SCORE_SIXTY := 60 %Score increasing by 60
const SCORE_FIFTY := 50  %Score increasing by 50
const SCORE_FOURTY := 40 %Score increasing by 40
const SCORE_THIRTY := 30 %Score increasing by 30
const SCORE_TWENTY := 20 %Score increasing by 20
const NO_SCORES : int := 0 %No scores

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Key presses
var chars : array char of boolean %Array of characters that stores key presses

%Mouse variables
var mx : int %X position of mouse
var my : int %Y position of mouse
var mp : int %If mouse is being pressed or not

%To do with opening song file (s)
var songNum : int %Value for opening .txt
var songNumPath : string %Path of the song

%Number of rows
var numRows : int := 10 %Number of rows

%The maximum and minimum amounts of rows that could be drawn
var minRow : int %Minimum row number to draw
var maxRow : int %Maximum row number to draw
var rowTimer : int := 0 %Timer to determine when to draw more rows

%The X value for the key pictures
var keyPressPicXs : array 1 .. 5 of int := init (60, 180, 300, 420, 540)
var keyCreatorPicXs : array 1 .. 5 of int := init (60, 160, 260, 360, 460)

%Arrays that store note information
var notesType : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores note types
var notesX : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores X position of notes
var notesY : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores Y position of notes
var notesSizeWidth : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores the width of the notes
var notesSizeHeight : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores the height of the notes
var notesTimer : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores the amount of time a note has been on the screen so it can be inlarged as its getting closer to the player
var colorNote : int %Color of the note about to be drawn
var noteImage : int %Image of the note to be drawn
var notesKeyCenterX : array 1 .. 5 of int %The X position of the center of the key notes
var notesMissed : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Array that stores if a player has missed a note

%Gives values to the center of the note key presses
notesKeyCenterX (1) := keyPressPicXs (1) + Pic.Width (keyPressPic1) div 2
notesKeyCenterX (2) := keyPressPicXs (2) + Pic.Width (keyPressPic2) div 2
notesKeyCenterX (3) := keyPressPicXs (3) + Pic.Width (keyPressPic3) div 2
notesKeyCenterX (4) := keyPressPicXs (4) + Pic.Width (keyPressPic4) div 2
notesKeyCenterX (5) := keyPressPicXs (5) + Pic.Width (keyPressPic5) div 2

%X's and Y's for different buttons/text
var buttonXs : array 1 .. 20 of int := init (280, 450, 280, 450, 280, 450, 280, 450, 140, 310, 420, 590, 270, 440, 570, 610, 570, 610, 580, 670) %X's for the main menu/settings buttons
var buttonYs : array 1 .. 20 of int := init (470, 540, 370, 440, 270, 340, 170, 240, 70, 140, 70, 140, 30, 100, 550, 600, 600, 650, 100, 130) %Y's for the menu buttons
var muteTextXs : array 1 .. 4 of int := init (250, 288, 330, 360) %X's for the mute text
var muteTextYs : array 1 .. 4 of int := init (500, 518, 500, 518) %Y's for the mute text
var arrowsX : array 1 .. 8 of int := init (590, 590, 580, 600, 590, 590, 580, 600) %X positions for the up and down arrow for the song creator and picking song
var arrowsY : array 1 .. 8 of int := init (560, 590, 570, 570, 640, 610, 630, 630) %Y positions for the up and down arrow for the song creator and picking song

%Boolean an array for if the mouse is hovering over a main menu/settings button
var buttonHover : array 1 .. 7 of boolean := init (false, false, false, false, false, false, false)

%Rows to draw
var rowDraw : int %Minimum row to start drawing

%Speed
var speed : int := 3 %Speed that notes move down

%The Y values for the lines of the moving background
var movingBackgroundYs : array 1 .. 7 of int := init (0, 0, 0, 0, 0, 0, 0)

%Boolean array for if the movingBackgroundYs not set
var setMovingBackground : array 1 .. 7 of boolean := init (false, false, false, false, false, false, false)

%The size of half of the note and half of
var notesCenterY : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int %Half the size of the notes

%Array that stores whether or not a note has been hit
var notesHit : flexible array 1 .. NUM_COLUMNS, 1 .. 0 of int

%Things to do with custom songs such as number of rows, name, and audio file
var customSongRows : int := 200 %Number of rows in the song
var customSongName : string := "CustomSong" %Name of the song

%Num to save the file and location to save it to
var customSongNum : int %Int for the song
var customSongNumPath : string := "Songs/" + customSongName + ".txt" %Path the song will save to

%Types of the notes, X and Y positions of it
var customNotesType : flexible array 1 .. NUM_COLUMNS, 1 .. customSongRows of int %Array that stores note types
var customNotesX : flexible array 1 .. NUM_COLUMNS, 1 .. customSongRows of int %Array that stores X position of notes
var customNotesY : flexible array 1 .. NUM_COLUMNS, 1 .. customSongRows of int %Array that stores Y position of notes

%Things to do with hovering of notes
var hoverNote : int := 11 %Color of the note hovering
var hoverImage : int := note6 %Image used for the note hovering
var hoverTile : boolean := false %Whether or not a tile is being hovered on

%Current kind of note that is selected
var selectedNote : string := "none" %Type of selected note

%Boolean that stores whether or not specified key is held
var spacePressed : boolean := false %Boolean variable for checking if the spacebar is being held
var mousePressed : boolean := false %Boolean variable for checking if the mouse button is being held

%Array for which key the user needs to press for different notes (red, blue, yellow, orange, green)
var notesKey : array 1 .. 5 of char := init ('a', 's', 'd', 'j', 'k')
var currentKey : array 1 .. 5 of string (1) := init ("a", "s", "d", "j", "k")

%Variables for the note streak
var noteStreak : int := 50 %Variable for your current note streak
var starPower : boolean := false %Boolean variable for if the star power is active
var noteStreakTimer : int := 0 %Variable for the timer of the note streak

%Variable for the score and the score multiplier
var score : int := 0 %The score of the game
var scoreMultiplier := 1 %The amount the score goes up by

%Variable for the rock meter
var rockMeter : int := 50 %The current state of the rock meter

%Variable to do with quitting program
var quitProgram : boolean := false %Quit program variable

%Variable for if points were added previously in the collision
var pointsAdded : array 1 .. 5 of boolean := init (false, false, false, false, false)

%Boolean to see if the minRow was added to
var minRowAdded : boolean := false

%Variables that have to do with the sound
var muteSound : boolean := false %Boolean to mute the sound in game
var musicPlayed : boolean := false %Boolean variable for music being played for the first time

%Variable for if there is a chord
var chordsCount : int := 0

%Variable for the the game music being played
var gameMusic : boolean := false

%Boolean array for controls being changed
var controlsChanged : array 1 .. 5 of boolean := init (false, false, false, false, false)

%Variable for the size of the chord
var chordSize : array 1 .. NUM_COLUMNS of int := init (0, 0, 0, 0, 0) %Array for the chord size after it has been hit but not fully
var chordSizeAdded : array 1 .. NUM_COLUMNS of boolean := init (false, false, false, false, false) %Array for if the chord size was inlarged

%The font for the title and for the button text
var titleFont : int := Font.New ("Times New Roman:75:bold") %declaring the font of the title
var textFont : int := Font.New ("Times New Roman:19:bold") %declaring of the button text
var textEnlarged : int := Font.New ("Times New Roman:23:bold") %declaring of the enlarged button text
var creatorFont : int := Font.New ("timesnewroman:15:bold") %The font for the song creator

%Variables that have to do with typing in the program
var input : string (1) %The key that the user has typed
var testString : string := "" %The string that the user has typed so far
var profileEntered : boolean := false %A boolean for if a profile has been entered yet
var keyPressed : boolean := false %A boolean for if a key has been pressed and is being held
var profileNotExist : boolean := false %A boolean for if the profile the user has entered does not exist

%File Input/Output Variables
var profileFilePath : flexible array 1 .. 0 of string %Location of the Profiles
var profileNames : flexible array 1 .. 0 of string %Profile Names
var profilesPassword : flexible array 1 .. 0 of string %Profile Passwords

%Profie Score Variables
var typeScore : flexible array 1 .. 0 of string %The type of scores
var profileScores : flexible array 1 .. 0 of int %Profile Scores
var scoreAmount : int %The score amount
var newScoreType : string %A new type of score
var newScore : int %A new score

%Profile Information and Password Variables
var newProfileName : string %A new profile
var newProfilePassword : string %A new profile password
var profileInfoPath : string := "Profiles/ProfilesInfo.txt" %Where all profile info is stored
var profileAmount : int %The amount of profiles
var profileChosen : string := "" %The profile that is chosen
var profilePassword : string := "" % The profile passwords
var profileName := false %Boolean for if a new name was already made
var profileMade := false %Boolean for if a new profile was made

%HighScore Profile Variables
var highScoreProfile : flexible array 1 .. 0 of string %The profile name, the number for the profile will be the same as the number for the file for the highScores array
var highScoreType : flexible array 1 .. 0 of string %The type of high score, the number for each type will be the same as the first number in the highScores array
var highScores : flexible array 1 .. 0, 1 .. 0 of int %It is 2D array because the first number represents which high score it is and the second number represents the profile

%User Response Variables
var fileNum : int % The file number
var userResponse : string %Response of the user

%Login Variables
var logInSuccess : boolean := false %Was the login sucessful
var logInFailed : boolean := false %Did the user type in the wrong password too many times
var wrongPassCount : int := 0 %Wrong password counter
var userKey : string %A random key that the user has typed in

%Focus of the program
var focus : string := MAIN_MENU

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var temp : int %Int variable that is used to store integers temporarily
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETTING UP IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Setting colours in images transparent
Pic.SetTransparentColor (note1, black) %Set the black color transparent in the note 1 image
Pic.SetTransparentColor (note2, black) %Set the black color transparent in the note 2 image
Pic.SetTransparentColor (note3, black) %Set the black color transparent in the note 3 image
Pic.SetTransparentColor (note4, black) %Set the black color transparent in the note 4 image
Pic.SetTransparentColor (note5, black) %Set the black color transparent in the note 5 image
Pic.SetTransparentColor (note6, black) %Set the black color transparent in the note 6 image
Pic.SetTransparentColor (keyPressPic1, black) %Set the black color transparent in the key 1 image
Pic.SetTransparentColor (keyPressPic2, black) %Set the black color transparent in the key 2 image
Pic.SetTransparentColor (keyPressPic3, black) %Set the black color transparent in the key 3 image
Pic.SetTransparentColor (keyPressPic4, black) %Set the black color transparent in the key 4 image
Pic.SetTransparentColor (keyPressPic5, black) %Set the black color transparent in the key 5 image

%Scaling images
mainBackgroundPic := Pic.Scale (mainBackgroundPic, 700, 700) %Scaling the main menu background to fit the size of the game

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB-PROGRAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pre : None
%Post : All values will be reset to restart the song
%Desription : This proceudre reset all the values for the song in order to replay to song
forward procedure ResetSong ()


%Pre : The text file with the song
%Post: All songs will be loaded from the txt file
%Description : This procedure loads all the songs from the text file
procedure LoadSong ()
    maxRow := 0
    minRow := 0

    %Reads everything from file
    open : songNum, songNumPath, get %Opens file
    get : songNum, numRows %Gets number of rows

    %Sets max bounds for arrays
    new notesType, NUM_COLUMNS, numRows
    new notesX, NUM_COLUMNS, numRows
    new notesY, NUM_COLUMNS, numRows
    new notesSizeWidth, NUM_COLUMNS, numRows
    new notesSizeHeight, NUM_COLUMNS, numRows
    new notesTimer, NUM_COLUMNS, numRows
    new notesHit, NUM_COLUMNS, numRows
    new notesCenterY, NUM_COLUMNS, numRows
    new notesMissed, NUM_COLUMNS, numRows

    %Rows first
    for r : 1 .. numRows
	%Then columns
	for c : 1 .. NUM_COLUMNS
	    get : songNum, notesType (c, r)
	    notesHit (c, r) := 0
	    notesMissed (c, r) := 0
	end for
    end for

    %Closes the file
    close : songNum
end LoadSong


%Pre : None
%Post : All profile information will be loaded
%Description : This procedure loads all the information of the profiles
procedure LoadProfilesInfo ()
    %Opens the file to get information
    open : fileNum, profileInfoPath, get
    %Gets the amount of profiles that exist
    get : fileNum, profileAmount

    %Sets new upper bounds to the amount of profile names and passwords
    new profileNames, profileAmount
    new profilesPassword, profileAmount

    %For loop for the amount of profiles there are
    for i : 1 .. profileAmount
	%Gets the profile name and password from the file
	get : fileNum, profileNames (i)
	get : fileNum, profilesPassword (i)
    end for

    %Close's the file
    close : fileNum
end LoadProfilesInfo


%Pre : None
%Post : If the user chooses too a new profile will be created
%Description : This profile allows the user to create a custom txt file for their new profile
procedure NewProfiles ()
    %Open the ProfilesInfo.txt file so infromation from it can be taken
    open : fileNum, profileInfoPath, get
    %Gets the amount of profiles that exist
    get : fileNum, profileAmount

    %Adds one to the amount of profiles
    profileAmount += 1

    %Sets new upper bounds for different arrays
    new profileFilePath, profileAmount
    new profileNames, profileAmount
    new profilesPassword, profileAmount

    %For loop for all the names and passwords but the last one cause it wasn't added yet
    for i : 1 .. profileAmount - 1
	%Get the names nad passwords
	get : fileNum, profileNames (i)
	get : fileNum, profilesPassword (i)
    end for

    %Close the file
    close : fileNum

    %Update the profileNames array and passwords with the new profile name
    profileNames (profileAmount) := newProfileName
    profilesPassword (profileAmount) := newProfilePassword

    %Update all the profile path's with their new values
    for i : 1 .. profileAmount
	profileFilePath (i) := "Profiles/" + profileNames (i) + "_Profile.txt"
    end for

    %Make a new profile by opening a file with the new path
    open : fileNum, profileFilePath (profileAmount), put
    %Putting no scores at the top because it was just created
    put : fileNum, NO_SCORES
    %Closing the file
    close : fileNum

    %Update the profile info .txt
    open : fileNum, profileInfoPath, put
    %Put the amount of profiles
    put : fileNum, profileAmount

    %For loop for the amount of profiles
    for i : 1 .. profileAmount
	%Put the profiles and passwords onto the txt file
	put : fileNum, profileNames (i)
	put : fileNum, profilesPassword (i)
    end for

    %Close the file
    close : fileNum
end NewProfiles


%Pre : None
%Post : A user-selected profile will be loaded
%Description : This procedure loads the profile that the user chooses
procedure LoadChosenProfile ()
    %Open the user's profile so the file can be loaded into the game
    open : fileNum, "Profiles/" + profileChosen + "_Profile.txt", get
    %Get the amount of scores
    get : fileNum, scoreAmount

    %Set new upper bounds to the amount of scores and the type of scores
    new profileScores, scoreAmount
    new typeScore, scoreAmount

    %For loop for the amount of scores
    for i : 1 .. scoreAmount
	%Get the tpye of scores and the score for each different score
	get : fileNum, typeScore (i)
	get : fileNum, profileScores (i)
    end for

    %Close the file
    close : fileNum
end LoadChosenProfile


%Pre : None
%Post : The chosen profile will be updated
%Description : This procedure updates the user-selected profile
procedure UpdateChosenProfile ()
    %Procedure needed to load all the profile names to check if a user has chose one of them
    LoadProfilesInfo ()

    temp := 0

    %Loop to check every profile name to see if the user chose an existing one
    loop
	temp += 1

	%If the user chose a profile to save to
	if (profileChosen = profileNames (temp)) then
	    exit

	    %If the user did not choose a profile to save to
	elsif (temp = profileAmount) then
	    exit
	end if
    end loop

    %If the user did choose a profile
    if (profileChosen = profileNames (temp)) then
	%Loads the chosen profile to update the score in the profile if needed to
	LoadChosenProfile ()

	temp := 0

	%If any scores exist
	if (scoreAmount > 0) then
	    %Loop used to check if there is a score for the song the user finished and if there is update the score if the score is smaller
	    loop
		temp += 1
		%If the current score is the same type as the new score
		if (typeScore (temp) = newScoreType) then
		    %If the score is smaller then the new score
		    if (profileScores (temp) < newScore) then
			profileScores (temp) := newScore
		    end if
		end if
		%Exit when the temp file is equal to the amount of scores or when the type of score is equal to the type of score of the new score
		exit when (temp = scoreAmount or typeScore (temp) = newScoreType)
	    end loop
	end if

	%If statement for if  there is no score for the song the user finished
	if (scoreAmount = 0 or typeScore (temp) not= newScoreType) then
	    %Open the chosen profile to get information
	    open : fileNum, "Profiles/" + profileChosen + "_Profile.txt", get
	    get : fileNum, scoreAmount

	    scoreAmount += 1

	    %Set new upper bounds
	    new typeScore, scoreAmount
	    new profileScores, scoreAmount

	    if (scoreAmount > 1) then
		%For loop for the scores except the last one
		for i : 1 .. scoreAmount - 1
		    %Get the type of scores and there scores
		    get : fileNum, typeScore (i)
		    get : fileNum, profileScores (i)
		end for
	    end if

	    %Close the file
	    close : fileNum

	    %Give the new part of the array its values with the new score values
	    typeScore (scoreAmount) := newScoreType
	    profileScores (scoreAmount) := newScore
	end if

	%Update the user's profile
	open : fileNum, "Profiles/" + profileChosen + "_Profile.txt", put
	%put the amount of scores
	put : fileNum, scoreAmount

	%For loop for the amount of scores
	for i : 1 .. scoreAmount
	    %Put the types of scores and there score
	    put : fileNum, typeScore (i)
	    put : fileNum, profileScores (i)
	end for

	%Close the file
	close : fileNum
    end if
end UpdateChosenProfile


%Pre: The song the user made
%Post: A custom song will be created
%Description: This procedure allows the user to create there own custom song
procedure CompileSong ()
    %Opens the file
    open : customSongNum, customSongNumPath, put
    %Puts the amount of rows
    put : customSongNum, customSongRows
    %Loop starting with rows
    for r : 1 .. customSongRows
	%Then columns, puts the type of note into it
	for c : 1 .. NUM_COLUMNS
	    put : customSongNum, customNotesType (c, r)
	end for
    end for
    %Closes the file
    close : customSongNum
end CompileSong


%Pre : None
%Post : The position for all notes will be set
%Desciption : This procedure sets the places for all the notes in the song
procedure SetPositions ()
    %Columns first
    for c : 1 .. NUM_COLUMNS
	%Then rows
	for r : 1 .. numRows
	    notesX (c, r) := ((c - 1) * DIAMETER) + X_ADJUSTMENT
	    notesY (c, r) := ((r - 1) * DIAMETER) + Y_ADJUSTMENT

	    notesCenterY (c, r) := notesY (c, r) + (Pic.Height (note1) div 2)
	end for
    end for

    %Set maxRow and minRow to the beginning of the song
    minRow := 1
    maxRow := 1
end SetPositions


%Pre : The files that need to be played
%Post : The music for the main screen will be played unless the user decides to mute it
%Description : This procedure plays the background music for the main screen and if the user decides to mute it, it stops
procedure PlayBackgroundMusic ()
    %If the sound is set to mute in settings
    if (muteSound = true) then
	Music.PlayFileStop
	%If the main menu background sound needs to be enabled
    elsif (muteSound = false and focus = MAIN_MENU or focus = SETTINGS) then
	Music.PlayFileLoop ("Audio/Soundtrack.mp3")
	%If the focus is the game
    elsif (focus = GAME) then
	%If the game music hasn't been enabled yet, enable it and set it to enabled
	if (gameMusic = false) then
	    Music.PlayFileLoop ("Audio/Slow Ride.mp3")
	    gameMusic := true
	end if
    end if
end PlayBackgroundMusic


%Pre : None
%Post : The game will be set up with the notes
%Desciption : This procedure sets up the information that is needed for the song to rung
procedure Setup ()
    %If the focus is the game
    if (focus = GAME) then
	LoadSong () %Loads the song that was chosen
	SetPositions () %Sets positions for the notes

	%For loop for the columns
	for c : 1 .. NUM_COLUMNS
	    %For loop for the rows
	    for r : 1 .. numRows
		notesSizeWidth (c, r) := 47 %47 original
		notesSizeHeight (c, r) := 23 %23 original
		notesTimer (c, r) := 0
	    end for
	end for
	%If the focus is to song creator
    elsif (focus = SONG_CREATOR) then
	%If the file for song creator exists
	if (File.Exists ("Songs/CustomSong.txt")) then
	    %Open the file to get information
	    open : customSongNum, customSongNumPath, get
	    %Get the amount of rows that are in the song
	    get : customSongNum, customSongRows

	    %Set new upper bounds to custom song arrays
	    new customNotesType, NUM_COLUMNS, customSongRows
	    new customNotesX, NUM_COLUMNS, customSongRows
	    new customNotesY, NUM_COLUMNS, customSongRows

	    %For loop for the rows
	    for r : 1 .. customSongRows
		%For loop for the columns
		for c : 1 .. NUM_COLUMNS
		    %Get every type of note
		    get : customSongNum, customNotesType (c, r)
		end for
	    end for
	    %Close the file
	    close : customSongNum
	else
	    %For loop for the rows
	    for r : 1 .. customSongRows
		%For loop for the columns
		for c : 1 .. NUM_COLUMNS
		    customNotesType (c, r) := 0
		end for
	    end for
	end if

	%Begins loading of notes with rows
	for r : 1 .. customSongRows
	    %Then columns
	    for c : 1 .. NUM_COLUMNS
		%Sets all types to 0, and sets X and Y postions
		customNotesType (c, r) := 0
		customNotesX (c, r) := keyCreatorPicXs (1) + ((c - 1) * Pic.Width (keyPressPic1)) + (5 * c)
		customNotesY (c, r) := NOTE_KEY_Y + Pic.Height (keyPressPic1) + (77 * (r - 1)) + (3 * r)
	    end for
	end for
    end if
end Setup


%Pre : The column and row must both be integers
%Post : If the note has been hit
%Description : If the notes have been hit it sets the notes hit array to hit
procedure NotesHitSet (column : int, row : int)
    %If the note is a short note
    if (notesType (column, row) = 1) then
	%If it hasn't been hit yet
	if (notesHit (column, row) = 0) then
	    notesHit (column, row) := 1
	end if
	%If the ntoe is a long note
    elsif (notesType (column, row) = 2) then
	%If the row is equal to one or the note one row under is a short note or there is nothing there
	if (row = 1 or notesType (column, row - 1) < 2) then
	    temp := row

	    loop
		%Exit when the note isn't a long note anymore
		exit when (notesType (column, temp) < 2 or temp = numRows)
		notesHit (column, temp) := 1
		temp += 1
	    end loop
	end if
    end if
end NotesHitSet


%Pre : The column and row must both be ints and the hit quality must be a string
%Post : Adds points based on how well the user hit the note
%Description : This procedure checks how well the user hit the note and adds score based on that
procedure NotePoints (column : int, row : int, quality : string)
    %If the points added for the column is false then set it to true
    if (pointsAdded (column) = false) then
	pointsAdded (column) := true
	%If the quality of the note is perfect then add the rock meter increment to the rock meter
	if (quality = "perfect") then
	    rockMeter += ROCK_METER_INCREMENT

	    %If the user doens't have star power then add the allocated amount
	    if (starPower = false) then
		noteStreak += NOTE_STREAK
	    end if

	    %Add sixty to the current score
	    score += SCORE_SIXTY * scoreMultiplier
	elsif (quality = "great") then
	    rockMeter += ROCK_METER_INCREMENT

	    %If the user doens't have star power then add the allocated amount
	    if (starPower = false) then
		noteStreak += NOTE_STREAK
	    end if

	    %Add fifty to the current score
	    score += SCORE_FIFTY * scoreMultiplier
	elsif (quality = "okay") then
	    rockMeter += ROCK_METER_INCREMENT

	    %If the user doens't have star power then add the allocated amount
	    if (starPower = false) then
		noteStreak += NOTE_STREAK
	    end if

	    %Add fourty to the current score
	    score += SCORE_FOURTY * scoreMultiplier
	elsif (quality = "bad") then
	    rockMeter += ROCK_METER_INCREMENT

	    %If the user doens't have star power then add the allocated amount
	    if (starPower = false) then
		noteStreak += NOTE_STREAK
	    end if

	    %Add thirty to the current score
	    score += SCORE_THIRTY * scoreMultiplier
	elsif (quality = "terrible") then
	    rockMeter += ROCK_METER_INCREMENT

	    %If the user doens't have star power then add the allocated amount
	    if (starPower = false) then
		noteStreak += NOTE_STREAK
	    end if

	    %Add twenty to the current score
	    score += SCORE_TWENTY * scoreMultiplier
	end if
    end if
end NotePoints


%Pre: They column for where the user has pressed is given
%Post: The user is told if they pressed the note on time and if they did there note streak goes up
%Desc: Procedure for checking if the user has pressed their key corresponding to the note (note detection)
procedure NoteCollisionDetection (column : int)
    var row : int

    %If minRow is greater then 1
    if (minRow > 1) then
	row := minRow + 1
	%If minRow is equal to one
    elsif (minRow = 1) then
	%If notes hit for the current column and the minRow is note 0
	if (notesHit (column, minRow) not= 0) then
	    row := minRow + 1
	else
	    %Anything else the row is equal to minRow
	    row := minRow
	end if
    else
	%Anything else the row is equal to minRow
	row := minRow
    end if

    %If the note is a short ntoe or a long note
    if (notesType (column, row) not= 0) then
	%If the note is pressed at a distance for it to be perfect
	if (abs (NOTE_KEY_CENTER_Y - notesCenterY (column, row)) <= Pic.Height (note1) div 5) then
	    NotePoints (column, row, "perfect")     %Procedure for adding score and rock meter points
	    NotesHitSet (column, row)
	    %If the note is pressed at a distance for it to be great
	elsif (abs (NOTE_KEY_CENTER_Y - notesCenterY (column, row)) <= Pic.Height (note1) div 4) then
	    NotePoints (column, row, "great")     %Procedure for adding score and rock meter points
	    NotesHitSet (column, row)
	    %If the note is pressed at a distance for it to be okay
	elsif (abs (NOTE_KEY_CENTER_Y - notesCenterY (column, row)) <= Pic.Height (note1) div 3) then
	    NotePoints (column, row, "okay")     %Procedure for adding score and rock meter points
	    NotesHitSet (column, row)
	    %If the note is pressed at a distance for it to be bad
	elsif (abs (NOTE_KEY_CENTER_Y - notesCenterY (column, row)) <= Pic.Height (note1) div 2) then
	    NotePoints (column, row, "bad")     %Procedure for adding score and rock meter points
	    NotesHitSet (column, row)
	    %If the note is pressed at a distance for it to be terrible
	elsif (abs (NOTE_KEY_CENTER_Y - notesCenterY (column, row)) <= Pic.Height (note1)) then
	    NotePoints (column, row, "terrible")     %Procedure for adding score and rock meter points
	    NotesHitSet (column, row)
	else
	    %If points added is false
	    if (pointsAdded (column) = false) then
		pointsAdded (column) := true
		noteStreak := 0
		rockMeter -= ROCK_METER_INCREMENT * 3
		scoreMultiplier := 1
	    end if
	end if
    else
	%If points added is false
	if (pointsAdded (column) = false) then
	    pointsAdded (column) := true
	    noteStreak := 0
	    rockMeter -= ROCK_METER_INCREMENT * 3
	    scoreMultiplier := 1
	end if
    end if
end NoteCollisionDetection


%Pre : The buttons must both be integers
%Post : The main screen buttons will be drawn
%Description : This procedure draws all the buttons for the main screen
procedure DrawMainMenuButtons (button1 : int, button2 : int)
    %Draw the a main menu button
    Draw.FillBox (buttonXs (button1), buttonYs (button1), buttonXs (button2), buttonYs (button2), red)             %Draw the outline's for the button box's
    Draw.FillBox (buttonXs (button1) + 10, buttonYs (button1) + 10, buttonXs (button2) - 10, buttonYs (button2) - 10, black)             %Draw the button box's

    %Draw the lines in the corner of the buttons to add a 3D effect
    Draw.Line (buttonXs (button1), buttonYs (button1), buttonXs (button1) + 10, buttonYs (button1) + 10, black)
    Draw.Line (buttonXs (button1), buttonYs (button2), buttonXs (button1) + 10, buttonYs (button2) - 10, black)
    Draw.Line (buttonXs (button2), buttonYs (button1), buttonXs (button2) - 10, buttonYs (button1) + 10, black)
    Draw.Line (buttonXs (button2), buttonYs (button2), buttonXs (button2) - 10, buttonYs (button2) - 10, black)
end DrawMainMenuButtons


%Pre : None
%Post : When you hover over a note in the settings information is shown about the note
%Description : This procedure shows information about the note when the mouse hovers over it
procedure SettingsNotesHover ()
    %If the mouse is hovering over the green note
    if (mx >= keyPressPicXs (1) and mx <= keyPressPicXs (1) + Pic.Width (note1) and my >= 280 and my <= 280 + Pic.Height (note1)) then
	Font.Draw ("Clicking on the green note will allow you to change the key for", 10, 200, textFont, white)
	Font.Draw ("pressing it in-game from the " + currentKey (1) + " key to what ever key you want.", 10, 180, textFont, white)
	%If the mouse is being held and wasn't held before
	if (mp = 1 and mousePressed = false) then
	    mousePressed := true
	    controlsChanged (1) := true
	    focus := CHANGING_CONTROLS
	end if
    end if

    %If the mouse if hovering over the red note
    if (mx >= keyPressPicXs (2) and mx <= keyPressPicXs (2) + Pic.Width (note2) and my >= 280 and my <= 280 + Pic.Height (note2)) then
	Font.Draw ("Clicking on the red note will allow you to change the key for", 10, 200, textFont, white)
	Font.Draw ("pressing it in-game from the " + currentKey (2) + " key to what ever key you want.", 10, 180, textFont, white)
	%If the mouse is being held and wasn't held before
	if (mp = 1 and mousePressed = false) then
	    mousePressed := true
	    controlsChanged (2) := true
	    focus := CHANGING_CONTROLS
	end if
    end if

    %If the mouse is hovering over the yellow note
    if (mx >= keyPressPicXs (3) and mx <= keyPressPicXs (3) + Pic.Width (note3) and my >= 280 and my <= 280 + Pic.Height (note3)) then
	Font.Draw ("Clicking on the yellow note will allow you to change the key for", 10, 200, textFont, white)
	Font.Draw ("pressing it in-game from the " + currentKey (3) + " key to what ever key you want.", 10, 180, textFont, white)
	%If the mouse is being held and wasn't held before
	if (mp = 1 and mousePressed = false) then
	    mousePressed := true
	    controlsChanged (3) := true
	    focus := CHANGING_CONTROLS
	end if
    end if

    %If the mouse is hovering over the blue note
    if (mx >= keyPressPicXs (4) and mx <= keyPressPicXs (4) + Pic.Width (note4) and my >= 280 and my <= 280 + Pic.Height (note4)) then
	Font.Draw ("Clicking on the blue note will allow you to change the key for", 10, 200, textFont, white)
	Font.Draw ("pressing it in-game from the " + currentKey (4) + " key to what ever key you want.", 10, 180, textFont, white)
	%If the mouse is being held and wasn't held before
	if (mp = 1 and mousePressed = false) then
	    mousePressed := true
	    controlsChanged (4) := true
	    focus := CHANGING_CONTROLS
	end if
    end if

    %If the mouse is hovering over the orange note
    if (mx >= keyPressPicXs (5) and mx <= keyPressPicXs (5) + Pic.Width (note5) and my >= 280 and my <= 280 + Pic.Height (note5)) then
	Font.Draw ("Clicking on the orange note will allow you to change the key for", 10, 200, textFont, white)
	Font.Draw ("pressing it in-game from the " + currentKey (5) + " key to what ever key you want.", 10, 180, textFont, white)
	%If the mouse is being held and wasn't held before
	if (mp = 1 and mousePressed = false) then
	    mousePressed := true
	    controlsChanged (5) := true
	    focus := CHANGING_CONTROLS
	end if
    end if
end SettingsNotesHover


%Pre : None
%Post: All game data will be updated
%Description : This procedure updates all the data in the game
procedure Update ()
    %If the focus is at settings, or instructions, or pick song menu, or profile
    if (focus = SETTINGS or focus = INSTRUCTIONS or focus = PICK_SONG or focus = PROFILE or focus = PICK_PROFILE or focus = NEW_PROFILE or focus = HIGHSCORES) then
	%If the mouse falls within the area of the button
	if (mx > buttonXs (13) and mx <= buttonXs (14) and my >= buttonYs (13) and my <= buttonYs (14)) then
	    buttonHover (7) := true
	    buttonXs (13) := 255
	    buttonXs (14) := 455
	    buttonYs (13) := 17
	    buttonYs (14) := 113

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		if (focus = PICK_PROFILE or focus = NEW_PROFILE or focus = HIGHSCORES) then
		    focus := PROFILE
		else
		    focus := MAIN_MENU
		end if
	    end if
	else
	    buttonHover (7) := false
	    buttonXs (13) := 270
	    buttonXs (14) := 440
	    buttonYs (13) := 30
	    buttonYs (14) := 100
	end if
    end if

    %If the focus is at settings
    if (focus = SETTINGS) then
	%If the mouse falls within the area of the button
	if (mx >= 250 and mx <= 288 and my >= 500 and my <= 518) then
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		muteSound := true
		PlayBackgroundMusic ()
	    end if
	end if

	%If the mouse falls within the area of the button
	if (mx >= 330 and mx <= 360 and my >= 500 and my <= 518) then
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		muteSound := false
		PlayBackgroundMusic ()
	    end if
	end if

	%If the focus is at the pick song menu
    elsif (focus = PICK_SONG) then
	%If the mouse falls within the area of the costum song text
	if (mx >= 260 and mx <= 430 and my >= 620 and my <= 642) then
	    %If the mouse is being held and wasn't held before
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		songNumPath := "Songs/" + customSongName + ".txt"
		newScoreType := "CostumSong"
		focus := GAME
		Setup ()
	    end if
	end if

	%If the mouse falls within the area of the Slow Ride (Easy) text
	if (mx >= 240 and mx <= 460 and my >= 560 and my <= 582) then
	    %If the mouse is being held and wasn't before
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		songNumPath := "Songs/Song.txt"
		newScoreType := "SlowRide(Easy)"
		focus := GAME
		Setup ()
	    end if
	end if

	%If the focus is at the profile
    elsif (focus = PROFILE) then
	%If the y position of the mouse is in the area of where the buttons are
	if (my >= 320 and my <= 380) then
	    %If the x position of the mouse is in the area of the load proifle button
	    if (mx >= 40 and mx <= 220) then
		%If the mouse is being held and wasn't before
		if (mp = 1 and mousePressed = false) then
		    mousePressed := true
		    focus := PICK_PROFILE
		    profileChosen := ""
		    profilePassword := ""
		    testString := ""
		    profileNotExist := false
		    profileEntered := false
		    logInSuccess := false
		    logInFailed := false
		end if
	    end if

	    %If the x position of the mouse is in the area of the highscore button
	    if (mx >= 260 and mx <= 440) then
		%If the mouse is being held and wasn't before
		if (mp = 1 and mousePressed = false) then
		    mousePressed := true
		    focus := HIGHSCORES
		end if
	    end if

	    %If the x position of the mouse is in the area of the new profile button
	    if (mx >= 480 and mx <= 660) then
		%If the mouse is being held and wasn't before
		if (mp = 1 and mousePressed = false) then
		    mousePressed := true
		    focus := NEW_PROFILE
		    testString := ""
		    newProfileName := ""
		    newProfilePassword := ""
		    profileName := false
		    profileMade := false
		end if
	    end if
	end if

	%If the focus is at picking the profile
    elsif (focus = PICK_PROFILE) then
	%If the user has typed in the wrong password 5 times
	if (wrongPassCount = 5) then
	    wrongPassCount := 0
	    logInFailed := true
	end if

	%If the user is presseing a key and the profile hasn't been entered yet and the user hasn't pressed a key before
	if (hasch and keyPressed = false and logInFailed = false and logInSuccess = false) then
	    getch (input)
	    %If the user has pressed the back space key
	    if (input = KEY_BACKSPACE) then
		%If the user hasn't entered a valid profile yet
		if (profileEntered = false) then
		    profileChosen := ""

		    %For loop to get rid of the last letter in the phrase
		    for a : 1 .. length (testString) - 1
			profileChosen += testString (a)
		    end for

		    testString := profileChosen

		    %If the user has entered a valid profile
		else
		    profilePassword := ""

		    %For loop to get rid of the last letter in the phrase
		    for a : 1 .. length (testString) - 1
			profilePassword += testString (a)
		    end for

		    testString := profilePassword
		end if
		%If the user has pressed the enter key
	    elsif (input = KEY_ENTER) then
		%If the user hasn't entered a valid profile yet
		if (profileEntered = false) then
		    profileChosen := testString

		    temp := 0

		    LoadProfilesInfo ()

		    loop
			temp += 1

			%If the profile that the user chose exists
			if (profileChosen = profileNames (temp)) then
			    profileEntered := true
			    wrongPassCount := 0
			    exit
			    %If the profile does not exist
			elsif (temp = profileAmount) then
			    profileNotExist := true
			    profileChosen := ""
			    exit
			end if
		    end loop

		    testString := ""

		    %If the user has entered a valid profile
		else
		    profilePassword := testString

		    %If the password of the profile is correct
		    if (profilePassword = profilesPassword (temp)) then
			LoadChosenProfile ()
			logInSuccess := true

			%If the password of the profile is not correct
		    else
			wrongPassCount += 1
			profilePassword := ""
		    end if
		end if

		testString := ""

		%Anything else that the user might have pressed
	    else
		%If the user hasn't entered a valid profile yet
		if (profileEntered = false) then
		    testString := testString + input
		    profileChosen := testString

		    %If the user has entered a valid profile
		else
		    testString := testString + input
		    profilePassword := testString
		end if
	    end if
	end if

	%Checks if a key is being pressed and has not been pressed earlier
	if (hasch and keyPressed = false) then
	    keyPressed := true
	end if

	%Checks if a key has been earlier pressed but is no longer being pressed
	if (hasch = false and keyPressed = true) then
	    keyPressed := false
	end if

	%If the focus is at creating a new profile
    elsif (focus = NEW_PROFILE) then
	%If the user is pressing a key and it wasn't pressed before and the profile hasn't been made yet
	if (hasch and keyPressed = false and profileMade = false) then
	    getch (input)

	    %If the user has pressed the back space key
	    if (input = KEY_BACKSPACE) then
		%If the profile hasn't been given a name yet
		if (profileName = false) then
		    newProfileName := ""

		    %For loop to get rid of the last letter in the phrase
		    for a : 1 .. length (testString) - 1
			newProfileName += testString (a)
		    end for

		    testString := newProfileName
		else
		    newProfilePassword := ""

		    %For loop to get rid of the last letter in the phrase
		    for a : 1 .. length (testString) - 1
			newProfilePassword += testString (a)
		    end for

		    testString := newProfilePassword
		end if

		%If the user has pressed the enter key
	    elsif (input = KEY_ENTER) then
		%If the profile hasn't been given a name yet
		if (profileName = false) then
		    profileName := true
		    newProfileName := testString
		    testString := ""
		else
		    newProfilePassword := testString
		    NewProfiles ()
		    testString := ""
		    profileMade := true
		end if

		%Anything else that the user might have pressed
	    else
		%If the profile hasn't been given a name yet
		if (profileName = false) then
		    testString := testString + input
		    newProfileName := testString
		else
		    testString := testString + input
		    newProfilePassword := testString
		end if
	    end if
	end if

	%Checks if a key is being pressed and has not been pressed earlier
	if (hasch and keyPressed = false) then
	    keyPressed := true
	end if

	%Checks if a key has been earlier pressed but is no longer being pressed
	if (hasch = false and keyPressed = true) then
	    keyPressed := false
	end if

	%If the focus is at the song creator
    elsif (focus = SONG_CREATOR) then
	if (mx >= buttonXs (13) - 30 and mx <= buttonXs (14) - 30 and my >= 10 and my <= 70) then
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		focus := MAIN_MENU
	    end if
	end if

	%If 0 is pressed the selected note is none
	if (chars ('0')) then
	    selectedNote := "none"
	    %If 1 is pressed the selected note is a short note
	elsif (chars ('1')) then
	    selectedNote := "shortNote"
	    %If 2 is pressed the selected note is a long note
	elsif (chars ('2')) then
	    selectedNote := "longNote"
	end if

	%If the mouse is pressed and has not earlier been pressed
	if (mp = 1 and (mousePressed = false)) then
	    %If the mouse falls within the area of the bottom arrow
	    if ((mx > buttonXs (15)) and (mx < buttonXs (16)) and (my > buttonYs (15)) and (my < buttonYs (16))) then
		%If minRow is greater than 1 then it can move down the rows
		if (minRow > 1) then
		    maxRow -= 1
		    minRow -= 1
		    %Moves everything down starting with colums
		    for c : 1 .. NUM_COLUMNS
			%And then rows
			for r : 1 .. customSongRows
			    customNotesY (c, r) += HEIGHT_TILE
			end for
		    end for
		end if
		%If the mouse falls within the area of the top arrow
	    elsif ((mx > buttonXs (17)) and (mx < buttonXs (18)) and (my > buttonYs (17)) and (my < buttonYs (18))) then
		%If maxRow is less than the total number of rows then it can all move up
		if (maxRow < customSongRows) then
		    maxRow += 1
		    minRow += 1
		    %Moves everything down starting with columns
		    for c : 1 .. NUM_COLUMNS
			%And then rows
			for r : 1 .. customSongRows
			    customNotesY (c, r) -= HEIGHT_TILE
			end for
		    end for
		end if
		%If the mouse falls within the area of the create button
	    elsif ((mx > buttonXs (19)) and (mx < buttonXs (20)) and (my > buttonYs (19)) and (my < buttonYs (20))) then
		%Calls the procedure which compiles the song
		CompileSong ()
	    end if

	    %Checks if mouse is being held and has not been pressed earlier
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
	    end if
	end if

	%Checks if mouse button is being held
	if (mp = 1) then
	    %Checks all the columns of the notes
	    for c : 1 .. NUM_COLUMNS
		%Checks all the rows that are visible on the screen
		for r : minRow .. maxRow
		    %If the mouse falls within the boundries for the notes
		    if ((mx >= customNotesX (c, r)) and (mx <= (customNotesX (c, r) + WIDTH_TILE)) and (my >= customNotesY (c, r)) and (my <= customNotesY (c, r) +
			    HEIGHT_TILE)) then
			%If there isn't a selected note
			if (selectedNote = "none") then
			    customNotesType (c, r) := 0
			    %If the selected note is a short note
			elsif (selectedNote = "shortNote") then
			    customNotesType (c, r) := 1
			    %If the selected note is a long note
			elsif (selectedNote = "longNote") then
			    customNotesType (c, r) := 2
			end if
		    end if
		end for
	    end for
	end if

	%Checks all the columns of the notes
	for c : 1 .. NUM_COLUMNS
	    %Checks all the rows that are visible on the screen
	    for r : minRow .. maxRow
		%Checks if note is hovering
		if (hoverTile = false) then
		    %If the mouse falls within the boundries for the notes
		    if ((mx >= customNotesX (c, r)) and (mx <= customNotesX (c, r) + WIDTH_TILE) and (my > NOTE_KEY_Y + Pic.Height (keyPressPic1))) then
			hoverTile := true
			%If the current column is 1
			if (c = 1) then
			    hoverImage := note1
			    hoverNote := 10
			    %If the current column is 2
			elsif (c = 2) then
			    hoverImage := note2
			    hoverNote := 12
			    %If the current column is 3
			elsif (c = 3) then
			    hoverImage := note3
			    hoverNote := 14
			    %If the current column is 4
			elsif (c = 4) then
			    hoverImage := note4
			    hoverNote := 9
			    %If the current column is 5
			elsif (c = 5) then
			    hoverImage := note5
			    hoverNote := 42
			end if
		    else
			hoverImage := note6
			hoverNote := 11
			hoverTile := false
		    end if
		end if
	    end for
	end for

	hoverTile := false
	%If the focus is at changing controls
    elsif (focus = CHANGING_CONTROLS) then
	%If the controls changed is equal to true
	if (controlsChanged (1) = true or controlsChanged (2) = true or controlsChanged (3) = true or controlsChanged (4) = true or controlsChanged (5) = true) then
	    %If the mouse positions line up with the button
	    if (mx >= 250 and mx <= 450 and my >= 160 and my <= 200) then
		%If the mouse is being clicked
		if (mp = 1 and mousePressed = false) then
		    controlsChanged (1) := false
		    controlsChanged (2) := false
		    controlsChanged (3) := false
		    controlsChanged (4) := false
		    controlsChanged (5) := false
		    mousePressed := true
		    focus := SETTINGS
		end if
	    end if
	end if
	%If the focus is at main menu
    elsif (focus = MAIN_MENU) then
	%If the mouse positions line up with the button
	if (mx >= buttonXs (1) and mx <= buttonXs (2) and my >= buttonYs (1) and my <= buttonYs (2)) then
	    buttonHover (1) := true
	    buttonXs (1) := 265
	    buttonXs (2) := 465
	    buttonYs (1) := 457
	    buttonYs (2) := 553

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		focus := PICK_SONG
		Setup ()
	    end if
	else
	    buttonHover (1) := false
	    buttonXs (1) := 280
	    buttonXs (2) := 450
	    buttonYs (1) := 470
	    buttonYs (2) := 540
	end if

	%If the mouse positions line up with the mouse
	if (mx >= buttonXs (3) and mx <= buttonXs (4) and my >= buttonYs (3) and my <= buttonYs (4)) then
	    buttonHover (2) := true
	    buttonXs (3) := 265
	    buttonXs (4) := 465
	    buttonYs (3) := 357
	    buttonYs (4) := 453

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		focus := SONG_CREATOR
		Setup ()
		minRow := 1
		maxRow := 7
	    end if
	else
	    buttonHover (2) := false
	    buttonXs (3) := 280
	    buttonXs (4) := 450
	    buttonYs (3) := 370
	    buttonYs (4) := 440
	end if

	%If the mouse positions line up with the buttons
	if (mx >= buttonXs (5) and mx <= buttonXs (6) and my >= buttonYs (5) and my <= buttonYs (6)) then
	    buttonHover (3) := true
	    buttonXs (5) := 265
	    buttonXs (6) := 465
	    buttonYs (5) := 257
	    buttonYs (6) := 353

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		focus := PROFILE
	    end if
	else
	    buttonHover (3) := false
	    buttonXs (5) := 280
	    buttonXs (6) := 450
	    buttonYs (5) := 270
	    buttonYs (6) := 340
	end if

	%If the mouse positions line up with the buttons
	if (mx >= buttonXs (7) and mx <= buttonXs (8) and my >= buttonYs (7) and my <= buttonYs (8)) then
	    buttonHover (4) := true
	    buttonXs (7) := 265
	    buttonXs (8) := 465
	    buttonYs (7) := 157
	    buttonYs (8) := 253

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		focus := INSTRUCTIONS
	    end if
	else
	    buttonHover (4) := false
	    buttonXs (7) := 280
	    buttonXs (8) := 450
	    buttonYs (7) := 170
	    buttonYs (8) := 240
	end if

	%If the mouse positions line up with the buttons
	if (mx >= buttonXs (9) and mx <= buttonXs (10) and my >= buttonYs (9) and my <= buttonYs (10)) then
	    buttonHover (5) := true
	    buttonXs (9) := 125
	    buttonXs (10) := 325
	    buttonYs (9) := 57
	    buttonYs (10) := 153

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		mousePressed := true
		focus := SETTINGS
	    end if
	else
	    buttonHover (5) := false
	    buttonXs (9) := 140
	    buttonXs (10) := 310
	    buttonYs (9) := 70
	    buttonYs (10) := 140
	end if

	%If the mouse positions line up with the buttons
	if (mx >= buttonXs (11) and mx <= buttonXs (12) and my >= buttonYs (11) and my <= buttonYs (12)) then
	    buttonHover (6) := true
	    buttonXs (11) := 405
	    buttonXs (12) := 605
	    buttonYs (11) := 57
	    buttonYs (12) := 153

	    %Checks if mouse is being held and has not been earlier pressed
	    if (mp = 1 and mousePressed = false) then
		quitProgram := true
		mousePressed := true
	    end if
	else
	    buttonHover (6) := false
	    buttonXs (11) := 420
	    buttonXs (12) := 590
	    buttonYs (11) := 70
	    buttonYs (12) := 140
	end if
	%If the focus is at the game
    elsif (focus = GAME) then
	%Call the background music procedure
	PlayBackgroundMusic ()

	%If the y of the maxRow row note is less then 0
	if (notesY (1, maxRow) < 0) then
	    newScore := score
	    UpdateChosenProfile ()
	    ResetSong ()
	    focus := MAIN_MENU
	    gameMusic := false
	    PlayBackgroundMusic ()
	end if

	%If the rock meter is equal to or less then 0
	if (rockMeter <= 0) then
	    newScore := score
	    UpdateChosenProfile ()
	    ResetSong ()
	    focus := MAIN_MENU
	    gameMusic := false
	    PlayBackgroundMusic ()
	end if

	%If the escape key is pressed
	if (chars (KEY_ESC)) then
	    ResetSong ()
	    focus := MAIN_MENU
	    gameMusic := false
	    PlayBackgroundMusic ()
	end if

	%If the space key is held and was not held before and that is the only key held
	if (chars (' ') and spacePressed = false and not chars (notesKey (1)) and not chars (notesKey (2)) and not chars (notesKey (3)) and not chars (notesKey (4))
		and not chars (notesKey (5))) then
	    noteStreak := 0
	    rockMeter -= ROCK_METER_INCREMENT * 3
	    spacePressed := true
	end if

	%If the space key wasn't held before
	if (spacePressed = false) then
	    %If the space key is being held
	    if (chars (' ')) then
		spacePressed := true
		%If the user has pressed the a key and the space key
		if (chars (notesKey (1))) then
		    NoteCollisionDetection (FIRST_COLUMN)         %Call the NoteCollisionDetection procedure
		end if

		%If the user has pressed the s key and the space key
		if (chars (notesKey (2))) then
		    NoteCollisionDetection (SECOND_COLUMN)         %Call the NoteCollisionDetection procedure
		end if

		%If the user has pressed the d key and the space key
		if (chars (notesKey (3))) then
		    NoteCollisionDetection (THIRD_COLUMN)         %Call the NoteCollisionDetection procedure
		end if

		%If the user has pressed the f key and the space key
		if (chars (notesKey (4))) then
		    NoteCollisionDetection (FOURTH_COLUMN)         %Call the NoteCollisionDetection procedure
		end if

		%If the user has pressed the g key and the space key
		if (chars (notesKey (5))) then
		    NoteCollisionDetection (FIFTH_COLUMN)         %Call the NoteCollisionDetection procedure
		end if
	    end if
	end if

	%For loop for the columns
	for c : 1 .. NUM_COLUMNS
	    %If the space key isn't being held
	    if not (chars (' ')) then
		%If the space key was held before
		if (spacePressed = true) then
		    spacePressed := false
		end if

		%If the points were added before
		if (pointsAdded (c) = true) then
		    pointsAdded (c) := false
		end if
	    end if
	end for

	%For loop for the columns
	for c : 1 .. NUM_COLUMNS
	    %If noteY for the minRow is less then 0
	    if (notesY (c, minRow) < 0) then
		%If the note wasn't hit
		if (notesHit (c, minRow) = 0) then
		    %If the note wasn't missed
		    if (notesMissed (c, minRow) = 0) then
			%If its a short note
			if (notesType (c, minRow) = 1) then
			    notesMissed (c, minRow) := 1
			    noteStreak := 0
			    rockMeter -= ROCK_METER_INCREMENT * 3
			    scoreMultiplier := 1
			    %If its a long note
			elsif (notesType (c, minRow) = 2) then
			    noteStreak := 0
			    rockMeter -= ROCK_METER_INCREMENT * 3
			    scoreMultiplier := 1

			    temp := minRow

			    loop
				%If its a long note
				if (notesType (c, temp) = 2) then
				    notesMissed (c, temp) := 2
				end if

				%Exit when the note is not a long note
				exit when (notesType (c, temp) not= 2)
				%If the temp is less then the amount of rows then temp is increased
				if (temp < numRows) then
				    temp += 1
				else
				    exit
				end if
			    end loop
			end if
		    end if
		end if
	    end if
	end for

	%If the user has pressed the enter key
	if (chars (KEY_ENTER)) then
	    %If the note streak is equal to or greater then what it needs to be to activate the double points multiplier
	    if (noteStreak >= 50) then
		noteStreak := 0         %Set the note streak to 0
		starPower := true         %Set star power to true
		scoreMultiplier *= 2         %Set the score multiplier to double what it normally is
	    end if
	end if

	%If the star power is active
	if (starPower = true) then
	    %If the score multiplier is equal to one
	    if (scoreMultiplier = 1) then
		scoreMultiplier := 2
	    end if
	end if

	%If the note streak is greater then 10 and the ntoe streak is less then 2-
	if (noteStreak > 10 and noteStreak <= 20) then
	    scoreMultiplier := 2
	    %If the ntoe streak is greater then 20 and the ntoe streak is less then 30
	elsif (noteStreak > 20 and noteStreak <= 30) then
	    scoreMultiplier := 3
	    %If the note streak is greater then 30
	elsif (noteStreak > 30) then
	    scoreMultiplier := 4
	end if

	%If the rock meter is greater then 100
	if (rockMeter > 100) then
	    rockMeter := 100
	    %If the rock meter is less then 0
	elsif (rockMeter < 0) then
	    rockMeter := 0
	end if

	%If the note streak timer is equal to or greater then 600 then the star power is off
	if (noteStreakTimer >= 600) then         %If the note streak timer is equal to 600
	    noteStreakTimer := 0         %Set note streak timer to 0
	    starPower := false         %Set teh star power to false
	    scoreMultiplier := scoreMultiplier div 2         %Set the score multiplier back to normal
	end if

	%If the star power boolean is true
	if (starPower = true) then
	    noteStreakTimer += 1         %Add one to the note streak timer
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%For loop for the rows
	for r : minRow .. maxRow
	    %For loop for the colums
	    for c : 1 .. NUM_COLUMNS
		%If the current note is a long note
		if (notesType (c, r) = 2) then
		    %If the current note has been hit
		    if (notesHit (c, r) = 1) then
			score += 1
			%If the column is equal to one
			if (c = 1) then
			    %If the key for the green note isn't being held
			    if not (chars (notesKey (1))) then
				notesHit (c, r) := 2
			    end if
			    %If the column is equal to two
			elsif (c = 2) then
			    %If the key for the red note isn't being held
			    if not (chars (notesKey (2))) then
				notesHit (c, r) := 2
			    end if
			    %If the column is equal to three
			elsif (c = 3) then
			    %If the key for the yellow ntoe isn't being held
			    if not (chars (notesKey (3))) then
				notesHit (c, r) := 2
			    end if
			    %If the column is equal to four
			elsif (c = 4) then
			    %if the key for the blue note isn't being held
			    if not (chars (notesKey (4))) then
				notesHit (c, r) := 2
			    end if
			    %If the column is equal to five
			elsif (c = 5) then
			    %If the key for the orange note isn't being held
			    if not (chars (notesKey (5))) then
				notesHit (c, r) := 2
			    end if
			end if
		    end if
		end if
	    end for
	end for

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%For loop for the columns
	for c : 1 .. NUM_COLUMNS
	    %For loop for the rows
	    for r : 1 .. upper (notesY, 2)
		notesY (c, r) -= speed
		notesCenterY (c, r) -= speed
	    end for
	end for

	%If max row is less then the number of rows
	if (maxRow < numRows) then
	    %Checks if the top of the note in the first column (could be any column) is less than the Y_ADJUSTMENT then maxRow is added by 1
	    if (notesY (1, maxRow) <= 700) then
		maxRow += 1
	    end if
	end if

	%If max rows is greater then the min rows
	if (maxRow > minRow) then
	    %Checks same note position as above but checks if the Y of the top of the note is under the bottom border, and if yes minRow is upped by 1
	    if (notesY (1, minRow) + Pic.Height (note1) < 0) then
		temp := 0

		minRowAdded := false

		%For loop for the columns
		for c : 1 .. NUM_COLUMNS
		    %If the minRow wasn't added yet
		    if (minRowAdded = false) then
			minRow += 1
			minRowAdded := true
		    end if
		end for
	    end if
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%If the min row is greater then one
	if (minRow > 1) then
	    temp := 1
	    loop
		%If the note is a long note
		if (notesType (temp, minRow - 1) = 2) then
		    chordsCount := 1
		    %If the note is a long note and the minimum row is greater then 2
		elsif (notesType (temp, minRow - 1) = 2 and minRow > 2) then
		    chordsCount := 2
		else
		    chordsCount := 0
		end if

		%exit when the temp is equal to 5 or chords count is greater then 0
		exit when (temp = 5 or chordsCount > 0)
		temp += 1
	    end loop
	end if

	%For loop for the columns
	for c : 1 .. NUM_COLUMNS
	    %For loop for the rows
	    for r : minRow .. maxRow
		notesTimer (c, r) += 1
		%If the notesTimer is at where the timer is soppused to reset
		if (notesTimer (c, r) = RESIZE_TIMER_MAX) then
		    notesTimer (c, r) := 0
		    notesSizeWidth (c, r) += 2
		    notesSizeHeight (c, r) += 1
		end if
	    end for
	end for

	%For loop for the columns
	for c : 1 .. NUM_COLUMNS
	    %For loop for the rows
	    for r : minRow .. maxRow
		%If  the note is not there or is a short note
		if (notesType (c, r) < 2) then
		    notesX (c, r) := notesKeyCenterX (c) - (notesSizeWidth (c, r) div 2)
		    %If the note is a long note
		elsif (notesType (c, r) = 2) then
		    notesX (c, r) := notesKeyCenterX (c) - (notesSizeWidth (c, r) div 2)
		end if
	    end for
	end for

	%If the maxRow plus 6 is still less then the amount of rows there are
	if (maxRow + 6 <= numRows) then
	    movingBackgroundYs (1) := notesY (1, minRow) - 40
	    movingBackgroundYs (2) := notesY (1, minRow + 1) - 40
	    movingBackgroundYs (3) := notesY (1, minRow + 2) - 40
	    movingBackgroundYs (4) := notesY (1, minRow + 3) - 40
	    movingBackgroundYs (5) := notesY (1, minRow + 4) - 40
	    movingBackgroundYs (6) := notesY (1, minRow + 5) - 40
	    movingBackgroundYs (7) := notesY (1, minRow + 6) - 40
	else
	    movingBackgroundYs (1) := notesY (1, maxRow) - 40
	    movingBackgroundYs (2) := movingBackgroundYs (1) - 100
	    movingBackgroundYs (3) := movingBackgroundYs (2) - 100
	    movingBackgroundYs (4) := movingBackgroundYs (3) - 100
	    movingBackgroundYs (5) := movingBackgroundYs (4) - 100
	    movingBackgroundYs (6) := movingBackgroundYs (5) - 100
	    movingBackgroundYs (7) := movingBackgroundYs (6) - 100
	end if
    end if
end Update


%Pre : None
%Post : The entire world will be drawn
%Description : This procedure draws the entire world for the program
procedure DrawWorld ()
    cls

    %If the game state is at the settings, instructions, picking the song, or choosing the profile then draw the button for it
    if (focus = SETTINGS or focus = INSTRUCTIONS or focus = PICK_SONG or focus = CHANGING_CONTROLS or focus = PROFILE or focus = PICK_PROFILE or focus = NEW_PROFILE or focus = HIGHSCORES) then
	Draw.FillBox (0, 0, maxx, maxy, black)
	%Draw the button that exits the settings menu for the settings menu
	Draw.FillBox (buttonXs (13), buttonYs (13), buttonXs (14), buttonYs (14), red)         %Draw the outline's for the button box's
	Draw.FillBox (buttonXs (13) + 10, buttonYs (13) + 10, buttonXs (14) - 10, buttonYs (14) - 10, black)         %Draw the button box's

	%Draw the lines in the corner of the buttons to add a 3D effect
	Draw.Line (buttonXs (13), buttonYs (13), buttonXs (13) + 10, buttonYs (13) + 10, black)
	Draw.Line (buttonXs (13), buttonYs (14), buttonXs (13) + 10, buttonYs (14) - 10, black)
	Draw.Line (buttonXs (14), buttonYs (13), buttonXs (14) - 10, buttonYs (13) + 10, black)
	Draw.Line (buttonXs (14), buttonYs (14), buttonXs (14) - 10, buttonYs (14) - 10, black)

	%If the mouse is hovered over the button then right an enlarged yellow text in the button
	if (buttonHover (7) = true) then
	    Font.Draw ("Go back", 300, 58, textEnlarged, yellow)         %Write the text in the button
	    %If not draw regular white text
	else
	    Font.Draw ("Go back", 310, 58, textFont, white)             %Write the text in the buttons
	end if
    end if

    %If the game state is in instructions then write out the instructions of the game
    if (focus = INSTRUCTIONS) then
	%Write the instrcutions
	Font.Draw ("The deafult keys are set to a for the green note, s", 10, 640, textFont, white)
	Font.Draw ("for the red note, d for the yellow note, j for the blue note,", 10, 620, textFont, white)
	Font.Draw ("and k for the orange note, but they are changeable in the", 10, 600, textFont, white)
	Font.Draw ("settings menu. To play you have to click the key corresponding", 10, 580, textFont, white)
	Font.Draw ("to the note colour and the space bar for the strum. If you would", 10, 560, textFont, white)
	Font.Draw ("like to go to the main menu during the game you can press the", 10, 540, textFont, white)
	Font.Draw ("Escape key to do so. If you have a note streak of at least 50", 10, 520, textFont, white)
	Font.Draw ("you can press the enter key and you will get your multiplier", 10, 500, textFont, white)
	Font.Draw ("doubled for about 15 seconds. Have fun playing Keyboard Hero!", 10, 480, textFont, white)

	%If the game state is in settings or changing the controls draw out the allocated buttons
    elsif (focus = SETTINGS or focus = CHANGING_CONTROLS) then
	Font.Draw ("Settings", 180, 600, titleFont, white)

	Font.Draw ("Mute all sound:", 10, 500, textFont, white)

	%If the user decides to mute the sound draw the mute sound buttons
	if (muteSound = true) then
	    Font.Draw ("Yes", 250, 500, textFont, red)
	    Font.Draw ("No", 330, 500, textFont, white)
	else
	    Font.Draw ("Yes", 250, 500, textFont, white)
	    Font.Draw ("No", 330, 500, textFont, red)
	end if

	%If the game state is in settings then show the note information
	if (focus = SETTINGS) then
	    SettingsNotesHover ()
	end if

	Font.Draw ("Click any one of the notes under here to change the key which is", 5, 400, textFont, white)
	Font.Draw ("used to click the note.", 5, 380, textFont, white)

	Pic.Draw (note1, keyPressPicXs (1), 280, picMerge)
	Pic.Draw (note2, keyPressPicXs (2), 280, picMerge)
	Pic.Draw (note3, keyPressPicXs (3), 280, picMerge)
	Pic.Draw (note4, keyPressPicXs (4), 280, picMerge)
	Pic.Draw (note5, keyPressPicXs (5), 280, picMerge)

	%If the game state is at changing the controls draw out the buttons and information allocated to it
	if (focus = CHANGING_CONTROLS) then
	    %If the first control is changed then draw all images/text allocated to it
	    if (controlsChanged (1) = true) then
		Draw.FillBox (150, 150, 550, 550, red)
		Font.Draw ("Click any key to change the key of", 160, 500, textFont, black)
		Font.Draw ("the green note.", 160, 480, textFont, black)
		Font.Draw ("The key is currently set to the " + currentKey (1) + " key.", 160, 420, textFont, black)
		%If the second control is changed then draw all images/text allocated to it
	    elsif (controlsChanged (2) = true) then
		Draw.FillBox (150, 150, 550, 550, red)
		Font.Draw ("Click any key to change the key of", 160, 500, textFont, black)
		Font.Draw ("the red note.", 160, 480, textFont, black)
		Font.Draw ("The key is currently set to the " + currentKey (2) + " key.", 160, 420, textFont, black)
		%If the third control is changed then draw all images/text allocated to it
	    elsif (controlsChanged (3) = true) then
		Draw.FillBox (150, 150, 550, 550, red)
		Font.Draw ("Click any key to change the key of", 160, 500, textFont, black)
		Font.Draw ("the yellow note.", 160, 480, textFont, black)
		Font.Draw ("The key is currently set to the " + currentKey (3) + " key.", 160, 420, textFont, black)
		%If the fourth control is changed then draw all images/text allocated to it
	    elsif (controlsChanged (4) = true) then
		Draw.FillBox (150, 150, 550, 550, red)
		Font.Draw ("Click any key to change the key of", 160, 500, textFont, black)
		Font.Draw ("the blue note.", 160, 480, textFont, black)
		Font.Draw ("The key is currently set to the " + currentKey (4) + " key.", 160, 420, textFont, black)
		%If the fifth control is changed then draw all images/text allocated to it
	    elsif (controlsChanged (5) = true) then
		Draw.FillBox (150, 150, 550, 550, red)
		Font.Draw ("Click any key to change the key of", 160, 500, textFont, black)
		Font.Draw ("the orange note.", 160, 480, textFont, black)
		Font.Draw ("The key is currently set to the " + currentKey (5) + " key.", 160, 420, textFont, black)
	    end if

	    Font.Draw ("Warning, some keys do not work", 160, 280, textFont, black)
	    Font.Draw ("properly with the game so if", 160, 260, textFont, black)
	    Font.Draw ("something is wrong try changing", 160, 240, textFont, black)
	    Font.Draw ("your keys.", 160, 220, textFont, black)

	    %If any of the controls are wanted to be changed draw the buttons for them
	    if (controlsChanged (1) = true or controlsChanged (2) = true or controlsChanged (3) = true or controlsChanged (4) = true or controlsChanged (5) = true) then
		Draw.FillBox (250, 160, 450, 210, white)         %Draw the outline's for the button box's
		Draw.FillBox (260, 170, 440, 200, black)         %Draw the button box's

		%Draw the lines in the corner of the buttons to add a 3D effect
		Draw.Line (250, 160, 260, 170, black)
		Draw.Line (250, 210, 260, 200, black)
		Draw.Line (450, 160, 440, 170, black)
		Draw.Line (450, 210, 440, 200, black)

		Font.Draw ("Cancel", 310, 178, textFont, white)
	    end if
	end if

	%If the game state is at picking a song then draw all images/text allocated to it
    elsif (focus = PICK_SONG) then
	Draw.ThickLine (50, 120, 650, 120, 10, white)
	Draw.ThickLine (50, 660, 650, 660, 10, white)
	Draw.ThickLine (50, 120, 50, 660, 10, white)
	Draw.ThickLine (650, 120, 650, 660, 10, white)

	Font.Draw ("Custom Song", 260, 620, textEnlarged, white)
	Font.Draw ("Slow Ride (Easy)", 240, 560, textEnlarged, white)

	%If the game state is at the song creator then draw all images/text allocated to it
    elsif (focus = PROFILE) then
	Font.Draw ("Would you like to load a profile, check the scores of", 10, 660, textEnlarged, white)
	Font.Draw ("all the profiles, or create a new profile?", 90, 620, textEnlarged, white)

	%If the mouse is in the area of the load profiles button
	if (mx >= 40 and mx <= 220 and my >= 320 and my <= 380) then
	    %Draw the text and the outline for the load profiles button yellow
	    Draw.FillBox (40, 320, 220, 380, yellow)
	    Draw.FillBox (45, 325, 215, 375, black)
	    Font.Draw ("Load Profile", 64, 343, textFont, yellow)
	else
	    %Draw the text and the outline for the load profiles button white
	    Draw.FillBox (40, 320, 220, 380, white)
	    Draw.FillBox (45, 325, 215, 375, black)
	    Font.Draw ("Load Profile", 64, 343, textFont, white)
	end if

	%If the mouse is in the area of the highscores button
	if (mx >= 260 and mx <= 440 and my >= 320 and my <= 380) then
	    %Draw the text and the outline for the highscores button yellow
	    Draw.FillBox (260, 320, 440, 380, yellow)
	    Draw.FillBox (265, 325, 435, 375, black)
	    Font.Draw ("Highscores", 290, 343, textFont, yellow)
	else
	    %Draw the text and the outline for the highscores button white
	    Draw.FillBox (260, 320, 440, 380, white)
	    Draw.FillBox (265, 325, 435, 375, black)
	    Font.Draw ("Highscores", 290, 343, textFont, white)
	end if

	%If the mouse is in the area of the new profiles button
	if (mx >= 480 and mx <= 660 and my >= 320 and my <= 380) then
	    %Draw the text and the outline for the new profiles button yellow
	    Draw.FillBox (480, 320, 660, 380, yellow)
	    Draw.FillBox (485, 325, 655, 375, black)
	    Font.Draw ("New profile", 510, 343, textFont, yellow)
	else
	    %Draw the text and the outline for the new profiles button white
	    Draw.FillBox (480, 320, 660, 380, white)
	    Draw.FillBox (485, 325, 655, 375, black)
	    Font.Draw ("New profile", 510, 343, textFont, white)
	end if

	%If the focus is at picking a new profile
    elsif (focus = PICK_PROFILE) then
	%If the profile has been entered
	if (profileEntered = false) then
	    %If the user has not entered a profile before
	    if (profileNotExist = false) then
		%Tell the user to type in the profile they want
		Font.Draw ("Please type in the name of the profile which you", 40, 660, textEnlarged, white)
		Font.Draw ("would like to load.", 230, 630, textEnlarged, white)
	    else
		%Tell the user that the profile they typed in does not exist and that they should try again
		Font.Draw ("The profile that you have entered does not exist.", 10, 660, textEnlarged, white)
		Font.Draw ("Please try again or go back to make a new profile.", 10, 630, textEnlarged, white)
	    end if

	    %Show the user what they are typing
	    Font.Draw (profileChosen, 10, 590, textEnlarged, white)
	else
	    %If the log in hasn't failed or succeded yet
	    if (logInSuccess = false and logInFailed = false and wrongPassCount = 0) then
		%Tell the user what is going on with their password
		Font.Draw ("Please type in the password for the profile that you", 10, 660, textEnlarged, white)
		Font.Draw ("have chosen.", 10, 630, textEnlarged, white)

		%Show the user what they are typing
		Font.Draw (profilePassword, 10, 590, textEnlarged, white)

		%If the user got their password wrong less then 5 times
	    elsif (wrongPassCount not= 5 and logInFailed = false and logInSuccess = false) then
		%Tell the user what is going on with their password
		Font.Draw ("That is the wrong password. You have " + intstr (5 - wrongPassCount) + " tries left to", 10, 660, textEnlarged, white)
		Font.Draw ("get the correct password.", 10, 630, textEnlarged, white)

		%Show the user what they are typing
		Font.Draw (profilePassword, 10, 590, textEnlarged, white)

		%If the user got their password wrong 5 times and the log in is failed
	    elsif (logInFailed = true and logInSuccess = false) then
		%Tell the user that they put in their password wrong too many times
		Font.Draw ("You have put in the wrong password too many times.", 10, 660, textEnlarged, white)
		Font.Draw ("Please try again later.", 10, 630, textEnlarged, white)

		%If the user has typed in the corrent password
	    elsif (wrongPassCount not= 5 and logInFailed = false and logInSuccess = true) then
		Font.Draw ("Welcome " + profileChosen + "!", 10, 660, textEnlarged, white)
		Font.Draw (profileChosen + ", you can now go play a song and the score for it", 10, 630, textEnlarged, white)
		Font.Draw ("will be saved onto this profile.", 10, 600, textEnlarged, white)
		Font.Draw ("If you do decide to click on the new profile or load", 10, 540, textEnlarged, white)
		Font.Draw ("profile button's on the last page then you will have to", 10, 510, textEnlarged, white)
		Font.Draw ("sign in again. Thank you for playing Keyboard Hero.", 10, 480, textEnlarged, white)
	    end if
	end if

	%If the focus is at creating a new profile
    elsif (focus = NEW_PROFILE) then
	if (profileMade = false) then
	    if (profileName = false) then
		%Tell the user that they should type the name of the profile they want to make
		Font.Draw ("Please type in the name of the profile which you want", 10, 660, textEnlarged, white)
		Font.Draw ("to make.", 10, 630, textEnlarged, white)

		%Show the user what they are typing
		Font.Draw (newProfileName, 10, 590, textEnlarged, white)
	    else
		%Tell the user to type the password of the profile they want to make
		Font.Draw ("Please type in the password for the profile you want", 10, 660, textEnlarged, white)
		Font.Draw ("to make", 10, 630, textEnlarged, white)

		%Show the user what they are typing
		Font.Draw (newProfilePassword, 10, 590, textEnlarged, white)
	    end if
	else
	    Font.Draw ("Good job on creating a new profile!", 10, 660, textEnlarged, white)
	    Font.Draw ("To start using your new profile just go back and load", 10, 630, textEnlarged, white)
	    Font.Draw ("your profile. As soon as your profile is loaded you can", 10, 600, textEnlarged, white)
	    Font.Draw ("play songs and there scores will be saved onto your", 10, 570, textEnlarged, white)
	    Font.Draw ("profile if its is logged in at the time you finished", 10, 540, textEnlarged, white)
	    Font.Draw ("your song. Thank you for playing Keyboard Hero!", 10, 510, textEnlarged, white)
	end if
    elsif (focus = SONG_CREATOR) then
	%Draw the background
	Draw.Fill (0, 0, black, 67)

	%Writes the instructions for the user
	Font.Draw ("Press the 1 key for short notes, 2 key for long notes, and 0 for nothing.", 10, 80, creatorFont, white)

	%Go back button
	Draw.FillBox (buttonXs (13) - 30, 10, buttonXs (14) - 30, 70, white)
	Draw.FillBox (buttonXs (13) - 25, 15, buttonXs (14) - 35, 65, black)
	Font.Draw ("Go back", buttonXs (13) + 15, 35, creatorFont, white)

	%Draw the keys
	Pic.Draw (keyPressPic1, keyCreatorPicXs (1), NOTE_KEY_Y, picMerge)         %Green key
	Pic.Draw (keyPressPic2, keyCreatorPicXs (2), NOTE_KEY_Y, picMerge)         %Red key
	Pic.Draw (keyPressPic3, keyCreatorPicXs (3), NOTE_KEY_Y, picMerge)         %Yellow key
	Pic.Draw (keyPressPic4, keyCreatorPicXs (4), NOTE_KEY_Y, picMerge)         %Blue key
	Pic.Draw (keyPressPic5, keyCreatorPicXs (5), NOTE_KEY_Y, picMerge)         %Orange key

	%Draw the lines to seperate the notes and show clear columns and rows
	Draw.ThickLine (keyCreatorPicXs (1), NOTE_KEY_Y, keyCreatorPicXs (1), 700, 5, grey)         %Vertical Line
	Draw.ThickLine (keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)), NOTE_KEY_Y, keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)), 700, 5, grey)         %Vertical Line
	Draw.ThickLine (keyCreatorPicXs (1), NOTE_KEY_Y, keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)), NOTE_KEY_Y, 5, grey)         %Horizontal Line
	Draw.ThickLine (keyCreatorPicXs (1), NOTE_KEY_Y + Pic.Height (keyPressPic1), keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)), NOTE_KEY_Y + Pic.Height (keyPressPic1), 5, grey)
	%Horizontal Line

	%Draws row lines
	for a : 1 .. maxRow
	    Draw.ThickLine (keyCreatorPicXs (1), NOTE_KEY_Y + Pic.Height (keyPressPic1) + (80 * a), keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)), NOTE_KEY_Y + Pic.Height (keyPressPic1)
		+ (80 *
		a), 5, grey)
	end for

	Draw.ThickLine (keyCreatorPicXs (1), 700, keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)), 700, 5, grey)
	%Draws column lines
	for a : 2 .. NUM_COLUMNS
	    Draw.ThickLine (keyCreatorPicXs (a) - 3, NOTE_KEY_Y, keyCreatorPicXs (a) - 3, 700, 5, grey)
	end for

	%Draws the arrow buttons
	Draw.FillBox (buttonXs (15), buttonYs (15), buttonXs (16), buttonYs (16), grey)
	Draw.FillBox (buttonXs (17), buttonYs (17), buttonXs (18), buttonYs (18), grey)
	Draw.ThickLine (buttonXs (15), buttonYs (17), buttonXs (16), buttonYs (17), 2, black)

	%Draws the arrows on the arrow buttons
	Draw.ThickLine (arrowsX (1), arrowsY (1), arrowsX (2), arrowsY (2), 5, black)
	Draw.ThickLine (arrowsX (1), arrowsY (1), arrowsX (3), arrowsY (3), 5, black)
	Draw.ThickLine (arrowsX (1), arrowsY (1), arrowsX (4), arrowsY (4), 5, black)
	Draw.ThickLine (arrowsX (5), arrowsY (5), arrowsX (6), arrowsY (6), 5, black)
	Draw.ThickLine (arrowsX (5), arrowsY (5), arrowsX (7), arrowsY (7), 5, black)
	Draw.ThickLine (arrowsX (5), arrowsY (5), arrowsX (8), arrowsY (8), 5, black)

	%Draws generate song button
	Draw.FillBox (buttonXs (19), buttonYs (19), buttonXs (20), buttonYs (20), grey)
	Font.Draw ("CREATE", buttonXs (19) + 6, buttonYs (19) + 6, creatorFont, green)

	%Draws the number of the min and max rows
	Font.Draw ("Min Row: ", keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)) + 10, 680, creatorFont, white)
	Font.Draw (intstr (minRow), keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)) + 110, 680, creatorFont, white)
	Font.Draw ("Max Row: ", keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)) + 10, 660, creatorFont, white)
	Font.Draw (intstr (maxRow), keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)) + 110, 660, creatorFont, white)

	%Count the number of columns
	for c : 1 .. NUM_COLUMNS
	    %Count the number of minimum to maximum rows
	    for r : minRow .. maxRow
		%Determines color, row 1 is green
		if (c = 1) then
		    colorNote := 10
		    noteImage := note1
		    %Row 2 is red
		elsif (c = 2) then
		    colorNote := 12
		    noteImage := note2
		    %Row 3 is yellow
		elsif (c = 3) then
		    colorNote := 14
		    noteImage := note3
		    %Row 4 is blue
		elsif (c = 4) then
		    colorNote := 9
		    noteImage := note4
		    %Row 5 is orange
		elsif (c = 5) then
		    colorNote := 42
		    noteImage := note5
		end if

		%If the note is a short note
		if (customNotesType (c, r) = 1) then
		    Pic.Draw (noteImage, customNotesX (c, r), customNotesY (c, r), picMerge)
		    %If the note is a long note
		elsif (customNotesType (c, r) = 2) then
		    Draw.ThickLine (customNotesX (c, r) + (Pic.Width (noteImage) div 2), customNotesY (c, r) + 10, customNotesX (c, r) + (Pic.Width (noteImage) div 2), customNotesY
			(c, r) + HEIGHT_TILE + 10, 20, colorNote)

		    %If the row is greater then 1
		    if (r > 1) then
			%If the note under is not a type two note
			if (customNotesType (c, r - 1) not= 2) then
			    Pic.Draw (noteImage, customNotesX (c, r), customNotesY (c, r), picMerge)
			end if
		    else
			Pic.Draw (noteImage, customNotesX (c, r), customNotesY (c, r), picMerge)
		    end if

		end if

	    end for
	end for

	%Draws the hovering note if the selected note is a short note or a long note
	if (selectedNote not= "none") then
	    if (selectedNote = "longNote") then
		Draw.ThickLine (mx, my - Pic.Height (hoverImage) div 2 + 10, mx, my - Pic.Height (hoverImage) div 2 + HEIGHT_TILE + 10, 20, hoverNote)
	    end if
	    Pic.Draw (hoverImage, mx - Pic.Width (hoverImage) div 2, my - Pic.Height (hoverImage) div 2, picMerge)
	elsif (selectedNote = "") then
	end if

	%Display the type of ntoe that is selected
	Font.Draw (selectedNote, keyCreatorPicXs (5) + (Pic.Width (keyPressPic1)) + 10, 500, creatorFont, red)

	%If the game state is at the main menu draw all images/text allocated to it
    elsif (focus = MAIN_MENU) then
	View.Set ("title: Keyboard Hero")
	%Draw the background picture
	Pic.Draw (mainBackgroundPic, 0, 0, picCopy)

	%Write the title
	Font.Draw ("Keyboard Hero", 20, 600, titleFont, white)

	DrawMainMenuButtons (1, 2)
	DrawMainMenuButtons (3, 4)
	DrawMainMenuButtons (5, 6)
	DrawMainMenuButtons (7, 8)
	DrawMainMenuButtons (9, 10)
	DrawMainMenuButtons (11, 12)

	%If the x and y values of the mouse match the x and y values of the buttons
	if (buttonHover (1) = true) then
	    Font.Draw ("Pick Song", 303, 495, textEnlarged, yellow)         %Write the text in the buttons
	else
	    Font.Draw ("Pick Song", 312, 495, textFont, white)         %Write the text in the buttons
	end if

	%If the x and y values of the mouse match the x and y values of the buttons
	if (buttonHover (2) = true) then
	    Font.Draw ("Song Creator", 279, 395, textEnlarged, yellow)         %Write the text in the buttons
	else
	    Font.Draw ("Song Creator", 295, 395, textFont, white)         %Write the text in the buttons
	end if

	%If the x and y values of the mouse match the x and y values of the buttons
	if (buttonHover (3) = true) then
	    Font.Draw ("Profiles", 315, 297, textEnlarged, yellow)         %Write the text in the buttons
	else
	    Font.Draw ("Profiles", 325, 297, textFont, white)         %Write the text in the buttons
	end if

	%If the x and y values of the mouse match the x and y values of the buttons
	if (buttonHover (4) = true) then
	    Font.Draw ("Instructions", 288, 197, textEnlarged, yellow)         %Write the text in the buttons
	else
	    Font.Draw ("Instructions", 303, 197, textFont, white)         %Write the text in the buttons
	end if

	%If the x and y values of the mouse match the x and y values of the buttons
	if (buttonHover (5) = true) then
	    Font.Draw ("Settings", 172, 97, textEnlarged, yellow)         %Write the text in the buttons
	else
	    Font.Draw ("Settings", 182, 97, textFont, white)         %Write the text in the buttons
	end if

	%If the x and y values of the mouse match the x and y values of the buttons
	if (buttonHover (6) = true) then
	    Font.Draw ("Quit Game", 434, 97, textEnlarged, yellow)         %Write the text in the buttons
	else
	    Font.Draw ("Quit Game", 446, 97, textFont, white)         %Write the text in the buttons
	end if

	%If the game state is at the game draw all images/text allocated to it
    elsif (focus = GAME) then
	%Set a new title
	View.Set ("title: Note Streak: " + intstr (noteStreak) + "        Rock Meter: " + intstr (rockMeter) + "        Score: " + intstr (score) + "        Score Multiplier: " +
	    intstr (scoreMultiplier))

	Draw.FillBox (0, 0, maxx, maxy, black)

	Draw.ThickLine (keyPressPicXs (1) - 13, 0, keyPressPicXs (1) - 13, maxy, 10, 21)
	Draw.ThickLine (keyPressPicXs (1) + Pic.Width (keyPressPic1) + 13, 0, keyPressPicXs (1) + Pic.Width (keyPressPic1) + 13, maxy, 10, 21)
	Draw.ThickLine (keyPressPicXs (2) + Pic.Width (keyPressPic2) + 13, 0, keyPressPicXs (2) + Pic.Width (keyPressPic2) + 13, maxy, 10, 21)
	Draw.ThickLine (keyPressPicXs (3) + Pic.Width (keyPressPic3) + 13, 0, keyPressPicXs (3) + Pic.Width (keyPressPic3) + 13, maxy, 10, 21)
	Draw.ThickLine (keyPressPicXs (4) + Pic.Width (keyPressPic4) + 13, 0, keyPressPicXs (4) + Pic.Width (keyPressPic4) + 13, maxy, 10, 21)
	Draw.ThickLine (keyPressPicXs (5) + Pic.Width (keyPressPic5) + 13, 0, keyPressPicXs (5) + Pic.Width (keyPressPic5) + 13, maxy, 10, 21)

	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (1), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (1), 10, 21)
	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (2), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (2), 10, 21)
	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (3), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (3), 10, 21)
	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (4), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (4), 10, 21)
	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (5), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (5), 10, 21)
	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (6), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (6), 10, 21)
	Draw.ThickLine (keyPressPicXs (1) - 13, movingBackgroundYs (7), keyPressPicXs (5) + Pic.Width (keyPressPic1) + 13, movingBackgroundYs (7), 10, 21)

	Pic.Draw (keyPressPic1, keyPressPicXs (1), NOTE_KEY_Y, picMerge)
	Pic.Draw (keyPressPic2, keyPressPicXs (2), NOTE_KEY_Y, picMerge)
	Pic.Draw (keyPressPic3, keyPressPicXs (3), NOTE_KEY_Y, picMerge)
	Pic.Draw (keyPressPic4, keyPressPicXs (4), NOTE_KEY_Y, picMerge)
	Pic.Draw (keyPressPic5, keyPressPicXs (5), NOTE_KEY_Y, picMerge)

	%Loops the rows to draw them
	for c : 1 .. NUM_COLUMNS
	    %Loops columns to determine color to draw with
	    for r : minRow - chordsCount .. maxRow
		%Determines color, row 1 is green
		if (starPower = true) then
		    colorNote := 11
		    noteImage := note6
		elsif (c = 1) then
		    colorNote := 10
		    noteImage := note1
		    %Row 2 is red
		elsif (c = 2) then
		    colorNote := 12
		    noteImage := note2
		    %Row 3 is yellow
		elsif (c = 3) then
		    colorNote := 14
		    noteImage := note3
		    %Row 4 is blue
		elsif (c = 4) then
		    colorNote := 9
		    noteImage := note4
		    %Row 5 is orange
		elsif (c = 5) then
		    colorNote := 42
		    noteImage := note5
		end if

		noteImage := Pic.Scale (noteImage, notesSizeWidth (c, r), notesSizeHeight (c, r))

		%If a certain note type is equal to
		if (notesType (c, r) = 1) then
		    if (notesHit (c, r) < 1 or notesMissed (c, minRow) = 1) then
			Pic.Draw (noteImage, notesX (c, r), notesY (c, r), picMerge)
		    end if
		elsif (notesType (c, r) = 2) then         %If it is 2 a long note is made
		    %Checks if row above can be checked
		    if (r < upper (notesType, 2)) then
			if (notesMissed (c, r) = 2) then
			    colorNote := gray
			end if

			%If ntoes hit for the is equal to 1
			if (notesHit (c, r) = 0) then
			    Draw.ThickLine (notesKeyCenterX (c), notesY (c, r) + 10, notesKeyCenterX (c), notesY (c, r + 1) + 10, notesSizeWidth (c, r) div 5, colorNote)
			    %If the ntoes is equal to 1 or 2
			elsif (notesHit (c, r) = 1 or notesHit (c, r) = 2) then
			    if (notesHit (c, r) = 2) then
				colorNote := gray
			    end if

			    %If the ntoes hit is equal to 2 or chord size wasn't added to yet
			    if (notesHit (c, r) = 2 and chordSizeAdded (c) = false) then
				chordSizeAdded (c) := true
				chordSize (c) += speed
			    end if

			    temp := r

			    loop
				if (temp + 1 <= upper (notesHit, 2)) then
				    if (notesType (c, temp + 1) = 2) then
					temp += 1
				    else
					exit when (notesType (c, temp + 1) < 2)
				    end if
				else
				    exit when (temp + 1 > upper (notesHit, 2) or temp + 1 > numRows)
				end if
			    end loop

			    if (temp + 1 <= numRows) then
				if (notesY (c, temp + 1) >= -10) then
				    if (notesHit (c, r) = 1) then
					if (notesY (c, temp + 1) > NOTE_KEY_CENTER_Y) then
					    Draw.ThickLine (notesKeyCenterX (c), NOTE_KEY_CENTER_Y, notesKeyCenterX (c), notesY (c, temp + 1), notesSizeWidth (c, r) div 5, colorNote)
					    %<--- Fix the temp + 1 issue, should not have to add 1
					end if
				    elsif (notesHit (c, r) = 2 and notesType (c, r) = 2) then
					Draw.ThickLine (notesKeyCenterX (c), NOTE_KEY_CENTER_Y - chordSize (c), notesKeyCenterX (c), notesY (c, temp + 1), notesSizeWidth (c, r) div 5,
					    colorNote)
				    end if
				else
				    chordSize (c) := 0
				end if
			    end if
			end if
			%Checks if row is greater than 1  and if it is checks if note under is a long note
			if (r > 1) then
			    %Checks if note type under is not 2
			    if (notesType (c, r - 1) < 2) then
				if (notesHit (c, r) = 0) then
				    Pic.Draw (noteImage, notesX (c, r), notesY (c, r), picMerge)
				end if
			    end if
			    %If it is row 1 and type is 2
			else
			    if (notesHit (c, r) = 0) then
				Pic.Draw (noteImage, notesX (c, r), notesY (c, r), picMerge)
			    end if
			end if
		    end if
		end if
		Pic.Free (noteImage)
	    end for
	    chordSizeAdded (c) := false
	end for
    end if
end DrawWorld

body ResetSong ()
%Procedure that resets the loading of the song
Setup ()

%Resetting variables that are needed for the song
chordsCount := 0         %Variable for if there is a chord
minRowAdded := false         %Boolean to see if the minRow was added to
pointsAdded (1) := false         %Variable for if points were added previously in the collision
pointsAdded (2) := false         %Variable for if points were added previously in the collision
pointsAdded (3) := false         %Variable for if points were added previously in the collision
pointsAdded (4) := false         %Variable for if points were added previously in the collision
pointsAdded (5) := false         %Variable for if points were added previously in the collision
rockMeter := 50         %The current state of the rock meter
score := 0         %The score of the game
noteStreak := 0         %Variable for your current note streak
starPower := false         %Boolean variable for if the star power is active
noteStreakTimer := 0         %Variable for the timer of the note streak
end ResetSong


%Pre : None
%Post : The game will be created
%Description : This procedure calls all necessary procedure, basically creating the game
procedure GameLoop ()
    %Calls setup
    Setup ()

    %Actual game loop
    loop
	if (focus = CHANGING_CONTROLS) then
	    if (hasch) then
		if (controlsChanged (1) = true) then
		    getch (currentKey (1))
		    notesKey (1) := currentKey (1)
		elsif (controlsChanged (2) = true) then
		    getch (currentKey (2))
		    notesKey (2) := currentKey (2)
		elsif (controlsChanged (3) = true) then
		    getch (currentKey (3))
		    notesKey (3) := currentKey (3)
		elsif (controlsChanged (4) = true) then
		    getch (currentKey (4))
		    notesKey (4) := currentKey (4)
		elsif (controlsChanged (5) = true) then
		    getch (currentKey (5))
		    notesKey (5) := currentKey (5)
		end if
	    end if
	elsif (focus not= PICK_PROFILE and focus not= NEW_PROFILE) then
	    %Get user input
	    Input.KeyDown (chars)
	end if

	%Get user input
	Mouse.Where (mx, my, mp)

	%Checks if the mouse isn't being held anymore and it has been held before
	if (mp = 0 and mousePressed = true) then
	    mousePressed := false
	end if

	%Plays the background music
	if (musicPlayed = false) then
	    musicPlayed := true
	    PlayBackgroundMusic ()
	end if

	%Calls Update and DrawWorld
	Update ()
	DrawWorld ()

	%Updates screen
	View.Update ()

	%Delays program
	delay (DELAY_PROGRAM)

	exit when (quitProgram = true)
    end loop

    Window.Close (WINDOW)
    Music.PlayFileStop ()

end GameLoop

%Calls gameloop procedure
GameLoop ()
