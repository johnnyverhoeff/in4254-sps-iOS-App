//
//  SettingsViewController.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 26-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import UIKit

import ParticleFilterKit

class SettingsViewController: UITableViewController, UITextFieldDelegate {

    var settings: Settings?
    
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var portTextField: UITextField!
    
    @IBOutlet var shouldRotateSwitch: UISwitch!
    @IBOutlet var shouldTrackProbableCellSwitch: UISwitch!
    
    @IBOutlet var wantParticlesSwitch: UISwitch!
    @IBOutlet var want1InEveryXParticlesLabel: UILabel!
    @IBOutlet var particleStepper: UIStepper!
    @IBOutlet var mapTypelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let settings = self.settings {
            setupView(settings)
        } else {
            setupView(Settings())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView(settings: Settings) {
        urlTextField.text = settings.url
        portTextField.text = settings.port
        
        shouldRotateSwitch.on = settings.shouldRotate
        shouldTrackProbableCellSwitch.on = settings.shouldTrackProbableCell
        
        wantParticlesSwitch.on = settings.clientParams.wantParticles
        want1InEveryXParticlesLabel.text = getCorrectLabelText(settings.clientParams.want1inEveryXParticles)
        particleStepper.value = Double(settings.clientParams.want1inEveryXParticles)
        mapTypelabel.text = settings.clientParams.mapType.rawValue
        
    }
    
    private func retrieveSettingsFromView() -> Settings {
        let newSettings = Settings()
        
        newSettings.url = urlTextField.text
        newSettings.port = portTextField.text
        
        newSettings.shouldRotate = shouldRotateSwitch.on
        newSettings.shouldTrackProbableCell = shouldTrackProbableCellSwitch.on

        newSettings.clientParams = ClientParameters()
        newSettings.clientParams.wantParticles = wantParticlesSwitch.on
        newSettings.clientParams.want1inEveryXParticles = Int(particleStepper.value)
        newSettings.clientParams.mapType = MapType.fromString(mapTypelabel.text!)
        
        return newSettings
    }
    
    private func getCorrectLabelText(value: Int) -> String {
        return "Want 1 in every \(value) particles"
    }

    @IBAction func particleStepperValueChanged(sender: UIStepper) {
        want1InEveryXParticlesLabel.text = getCorrectLabelText(Int(sender.value))
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "saveSettingsSegue" {
            
            self.settings = retrieveSettingsFromView()
            
        } else if segue.identifier == "cancelSettingsSegue" {
            println("cancel segue")
            
            // do stuff
        } else if segue.identifier == "MapTypePickerSegue" {
            if let mapTypePickerViewController = segue.destinationViewController as? MapTypePickerTableViewController {
                mapTypePickerViewController.selectedMap = self.settings?.clientParams.mapType
            }
        }
    }
    
    @IBAction func selectedMapType(segue: UIStoryboardSegue) {
        if let mapTypePicker = segue.sourceViewController as? MapTypePickerTableViewController {
            if let selectedMapType = mapTypePicker.selectedMap {
                mapTypelabel.text = selectedMapType.rawValue
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
