package xxl.core;

import java.io.*;
import java.util.ArrayList;

import xxl.app.exception.InvalidCellRangeException;
import xxl.app.exception.UnknownFunctionException;
import xxl.core.exception.*;

// FIXME import classes

/**
 * Class representing a spreadsheet application.
 */
public class Calculator {
  /** The current spreadsheet. */
  private Spreadsheet _spreadsheet = null;
  private User _activeUser;
  private ArrayList<User> _users;
  public Calculator() {

    _activeUser = new User("root");
    _users = new ArrayList<User>();
    _users.add(_activeUser);
  }
  public boolean createUser(String name){
      User user = new User(name);
      _users.add(user);
      return true;
  }

  public ArrayList<User> getUsers(){
	return _users;
  }

  public void newUsers(ArrayList<User> newusers){
	_users = newusers;
  }
  public void setActiveUser(User user){
    _activeUser=user;
  }
  public User getActiveUser(){
    return _activeUser;
  }
  public void createSpreadSheet(int width, int height ) throws InvalidCellRangeException{
	if (height>=width){
    	Spreadsheet sheet = new Spreadsheet(width, height);
	
		sheet.setActiveUser(_activeUser);
		_spreadsheet = sheet;
	}
	else throw new InvalidCellRangeException(height+";"+width);
  }

  // FIXME add more fields and methods if needed

  /**
   * Return the current spreadsheet.
   *
   * @returns the current spreadsheet of this application. This reference can be null.
   */
  public Spreadsheet getSpreadsheet() {
    return _spreadsheet;
  }
  /**
   * Set the current spreadsheet.
   *
   * @param sheet the new spreadsheet of this application.
   */
  public void setSpreadsheet(Spreadsheet sheet){
    _spreadsheet = sheet;    
  }

  /**
   * Saves the serialized application's state into the specified file. The current network is
   * associated to this file.
   *
   * @param filename the name of the file.
   * @throws FileNotFoundException if for some reason the file cannot be created or opened.
   * @throws MissingFileAssociationException if the current network does not have a file.
   * @throws IOException if there is some error while serializing the state of the network to disk.
   */
  public void saveAs(String filename) throws /*FileNotFoundException, MissingFileAssociationException, */IOException {
    // FIXME implement serialization method and throw exceptions
	_spreadsheet.setChanged(false);
	ObjectOutputStream obOut = null;
	try {

	obOut = new ObjectOutputStream(new FileOutputStream(filename));

	obOut.writeObject(_spreadsheet);

	} 
	
	finally {

	if (obOut != null)
	obOut.close();

	}
  }
  

  /**
   * @param filename name of the file containing the serialized application's state
   *        to load.
   * @throws UnavailableFileException if the specified file does not exist or there is
   *         an error while processing this file.
   */
  public void load(String filename) throws UnavailableFileException, MissingFileAssociationException, IOException {
		ObjectInputStream objIn = null;
    try {
	  objIn = new ObjectInputStream(new FileInputStream(filename));
      _spreadsheet = (Spreadsheet) objIn.readObject();
	  _spreadsheet.setChanged(false);
    } catch (IOException | ClassNotFoundException e) {
      throw new UnavailableFileException(filename);
    }
	finally {
		if (objIn != null)
		objIn.close();
		}
  }


  /**
   * Read text input file and create domain entities.
   *
   * @param filename name of the text input file
   * @throws ImportFileException
 * @throws UnknownFunctionException
   */

  public void importFile(String filename) throws UnrecognizedEntryException, IOException, ImportFileException, OutOfBoundsException, UnknownFunctionException {
	Parser _parser = new Parser();
    setSpreadsheet(_parser.parseFile(filename));
  }


}
