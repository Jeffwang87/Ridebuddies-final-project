//
//  ViewController.swift
//  UberShare
//
//  Created by wxt on 4/16/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import GoogleSignIn

class RideListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var rides: Rides!
    var ride: Ride!
    var photo: Photo!
    var authUI: FUIAuth!
    var photos: Photos!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        if ride == nil{
            ride = Ride()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        rides = Rides()
        photos = Photos()
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "sharecar.png")!)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        rides.loadData {
            self.tableView.reloadData()
        }
        
    }
    
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }else {
            tableView.isHidden = false
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRide"{
            let destination = segue.destination as! RideDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.ride = rides.RideArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func SignOutButtonPressed(_ sender: UIBarButtonItem) {
        do{
            try authUI!.signOut()
            print("signed out")
            tableView.isHidden = true
            signIn()
        }catch {
            print("couldn't sign out")
            tableView.isHidden = true
        }
    }
}

extension RideListViewController: UITableViewDelegate, UITableViewDataSource{
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rides.RideArray.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RideTableViewCell
    cell.NameLabel.text = rides.RideArray[indexPath.row].name
    cell.configureCell(ride: rides.RideArray[indexPath.row])
    return cell
}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 121
    }
}

extension RideListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
}
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            tableView.isHidden = false
        }
    }
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.green
        
        let marginInserts: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInserts, y: imageY, width: self.view.frame.width - (marginInserts*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "ride")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
}
