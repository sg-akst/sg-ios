//
//  FeedPostData.swift
//  SportsGravy
//
//  Created by CSS on 02/04/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class FeedPostData
    {
        
        //var name: String = ""
        //var age: Int = 0
        var id: Int = 0
        var feedPostedUser_id: String = ""
        var feedPostedUser_firstName: String = ""
        var feedPostedUser_lastName: String = ""
        var feedPostedUser_middleInitial: String = ""
        var feedPostedUser_suffix: String = ""
        var feedPostedUser_role: String = ""
        var feedPostedUser_avatar: String = ""
        var  feedText: String = ""
        var feedImageURL: String!
        var feedVideoURL: String = ""
        var lastSelectedFeededLevel: String = ""
        var feedPostedOrg_id: String = ""
        var feedPostedOrg_name: String = ""
        var feedPostedOrg_abbre: String = ""
        var tag_id: String = ""
        var tag_name: String = ""
        var cannedResponseTitle: String = ""
        var cannedResponseDesc: String = ""
        var reaction: String = ""
        var level_id: String = ""
        var level_name: String = ""
        var membergroup_id: String = ""
        var membergroup_name: String = ""
        var organization_id: String = ""
        var organization_name: String = ""
        var season_id: String = ""
        var season_label: String = ""
        var sport_id: String = ""
        var sport_name: String = ""
        var team_id: String = ""
        var team_name: String = ""
        var user_id: String = ""
        var user_name: String = ""
        var feedOrg_id: String = ""
        
    init(id:Int,feedPostedUser_id: String, feedPostedUser_firstName: String,feedPostedUser_lastName: String,feedPostedUser_middleInitial: String,feedPostedUser_suffix: String,feedPostedUser_role: String,feedPostedUser_avatar: String,feedText: String,feedImageURL: String,feedVideoURL: String,lastSelectedFeededLevel: String,feedPostedOrg_id: String,feedPostedOrg_name: String,feedPostedOrg_abbre: String,tag_id: String,tag_name: String,cannedResponseTitle: String,cannedResponseDesc: String,reaction: String,feedOrg_id: String,level_id:String, level_name: String,membergroup_id: String,membergroup_name: String,organization_id: String,organization_name: String,season_id: String,season_label: String,sport_id: String,sport_name: String,team_id: String,team_name: String,user_id: String,user_name: String)
        {
            self.id = id
            self.feedPostedUser_id = feedPostedUser_id
            self.feedPostedUser_firstName = feedPostedUser_firstName
            self.feedPostedUser_lastName = feedPostedUser_lastName
            self.feedPostedUser_middleInitial = feedPostedUser_middleInitial
            self.feedPostedUser_suffix = feedPostedUser_suffix
            self.feedPostedUser_role = feedPostedUser_role
            self.feedPostedUser_avatar = feedPostedUser_avatar
            self.feedText = feedText
            self.feedImageURL = feedImageURL
            self.feedVideoURL = feedVideoURL
            self.lastSelectedFeededLevel = lastSelectedFeededLevel
            self.feedPostedOrg_id = feedPostedOrg_id
            self.feedPostedOrg_name = feedPostedOrg_name
            self.feedPostedOrg_abbre = feedPostedOrg_abbre
            self.tag_id = tag_id
            self.tag_name = tag_name
            self.cannedResponseTitle = cannedResponseTitle
            self.cannedResponseDesc = cannedResponseDesc
            self.reaction = reaction
            self.feedOrg_id = feedOrg_id
            self.level_id = level_id
            self.level_name = level_name
            self.membergroup_id = membergroup_id
            self.membergroup_name = membergroup_name
            self.organization_id = organization_id
            self.organization_name = organization_name
            self.season_id = season_id
            self.season_label = season_label
            self.sport_id = sport_id
            self.sport_name = sport_name
            self.team_id = team_id
            self.team_name = team_name
            self.user_id = user_id
            self.user_name = user_name
        }
        
    }

