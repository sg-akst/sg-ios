import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,postuser_id TEXT,postuser_firstName TEXT, postuser_lastName TEXT, postuser_middleInitial TEXT, postuser_suffix TEXT, postuser_role TEXT, postuser_avatar TEXT, postuser_feedText TEXT,postuser_feedImageURL TEXT, postuser_feedVideoURL TEXT, postuser_Level TEXT, postuserOrg_id TEXT,postuser_Org_name TEXT, postuser_Org_abbre TEXT, postuser_tag_id TEXT, postuser_Title TEXT, cannedResponseDesc TEXT, reaction TEXT,feedOrg_id TEXT,level_id TEXT, level_name TEXT,membergroup_id TEXT, membergroup_name TEXT,organization_id TEXT,organization_name TEXT,season_id TEXT,season_name TEXT,sport_id TEXT, sport_name TEXT,team_id TEXT, team_name TEXT,user_id TEXT, user_name TEXT );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(Id: Int,postuser_id: String,postuser_firstName:String,postuser_lastName: String,postuser_middleInitial: String,postuser_suffix: String,postuser_role: String,postuser_avatar:String,postuser_feedText: String,postuser_feedImageURL: String,postuser_feedVideoURL:String,postuser_Level:String,postuserOrg_id:String,postuser_Org_name:String,postuser_Org_abbre:String,postuser_tag_id: String,postuser_Title:String,cannedResponseDesc: String,reaction:String,feedOrg_id: String, level_id: String, level_name: String,membergroup_id: String, membergroup_name: String, organization_id: String, organization_name: String,season_id: String, season_name: String,sport_id: String, sport_name: String,team_id: String,team_name: String,user_id: String,user_name: String)
    {
        let persons = read()
        for p in persons
        {
            if p.id == Id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO person (Id,postuser_id,postuser_firstName,postuser_lastName,postuser_middleInitial,postuser_suffix,postuser_role,postuser_avatar,postuser_feedText,postuser_feedImageURL,postuser_feedVideoURL,postuser_Level,postuserOrg_id,postuser_Org_name,postuser_Org_abbre,postuser_tag_id,postuser_Title,cannedResponseDesc,reaction,feedOrg_id,level_id,level_name,membergroup_id,membergroup_name,organization_id,organization_name,season_id,season_name,sport_id,sport_name,team_id,team_name,user_id, user_name) VALUES (NULL,?, ?, ?, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (postuser_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (postuser_firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (postuser_lastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (postuser_middleInitial as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (postuser_suffix as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (postuser_role as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (postuser_avatar as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (postuser_feedText as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (postuser_feedImageURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (postuser_feedVideoURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, (postuser_Level as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, (postuserOrg_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, (postuser_Org_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 14, (postuser_Org_abbre as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 15, (postuser_tag_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 16, (postuser_Title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 17, (cannedResponseDesc as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 18, (reaction as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 19, (feedOrg_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 20, (level_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 21, (level_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 22, (membergroup_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 23, (membergroup_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 24, (organization_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 25, (organization_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 26, (season_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 27, (season_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 28, (sport_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 29, (sport_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 30, (team_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 31, (team_name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 32, (user_id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 33, (user_name as NSString).utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [FeedPostData] {
        let queryStatementString = "SELECT * FROM person;"  //order by id asc limit = 1
        var queryStatement: OpaquePointer? = nil
        var psns : [FeedPostData] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let postuser_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let postuser_firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let postuser_lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let postuser_middleInitial = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let postuser_suffix = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let postuser_role = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let postuser_avatar = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let postuser_feedText = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let postuser_feedImageURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let postuser_feedVideoURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                let postuser_Level = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
                let postuserOrg_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 12)))
                let postuser_Org_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 13)))
                let postuser_Org_abbre = String(describing: String(cString: sqlite3_column_text(queryStatement, 14)))
                 let postuser_tag_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 15)))
                let postuser_Title = String(describing: String(cString: sqlite3_column_text(queryStatement, 16)))
                let cannedResponseDesc = String(describing: String(cString: sqlite3_column_text(queryStatement, 17)))
                let reaction = String(describing: String(cString: sqlite3_column_text(queryStatement, 18)))
                let feedOrg_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 19)))
                let level_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 20)))
                let level_name = String(describing: String(cString: sqlite3_column_text(queryStatement,21)))
                let membergroup_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 22)))
                let membergroup_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 23)))
                let organization_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 24)))
                let organization_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 25)))
                let season_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 26)))
                let season_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 27)))
                let sport_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 28)))
                let sport_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 29)))
                let team_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 30)))
                let team_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 31)))
                let user_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 32)))
                let user_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 33)))
                psns.append(FeedPostData(id: Int(id), feedPostedUser_id: postuser_id, feedPostedUser_firstName: postuser_firstName, feedPostedUser_lastName: postuser_lastName, feedPostedUser_middleInitial: postuser_middleInitial, feedPostedUser_suffix: postuser_suffix, feedPostedUser_role: postuser_role, feedPostedUser_avatar: postuser_avatar, feedText: postuser_feedText, feedImageURL: postuser_feedImageURL, feedVideoURL: postuser_feedVideoURL, lastSelectedFeededLevel: postuser_Level, feedPostedOrg_id: postuserOrg_id, feedPostedOrg_name: postuser_Org_name, feedPostedOrg_abbre: postuser_Org_abbre, tag_id: postuser_tag_id, cannedResponseTitle: postuser_Title, cannedResponseDesc: cannedResponseDesc, reaction: reaction, feedOrg_id: feedOrg_id, level_id: level_id, level_name: level_name, membergroup_id: membergroup_id, membergroup_name: membergroup_name, organization_id: organization_id, organization_name: organization_name, season_id: season_id, season_label: season_name, sport_id: sport_id, sport_name: sport_name, team_id: team_id, team_name: team_name, user_id: user_id, user_name: user_name))
                print("Query Result:")
               // print("\(id) | \(name) | \(year)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
