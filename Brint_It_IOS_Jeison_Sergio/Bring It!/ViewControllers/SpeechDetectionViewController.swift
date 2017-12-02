//
//  SpeechDetectionViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/13/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import Speech

class SpeechDetectionViewController: UIViewController, SFSpeechRecognizerDelegate {

   
  
    
    @IBOutlet weak var nameProductTextField: UITextField!
   
    @IBOutlet weak var quantityProductTextField: UITextField!
    @IBOutlet weak var microphoneButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "es-ES"))
    
    private var controlSpeech: Bool = true
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
       
        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func microphoneTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start", for: .normal)
            microphoneButton.setImage(#imageLiteral(resourceName: "Micro"), for: .normal)
            nameProductTextField.text = ""
            quantityProductTextField.text = ""
            self.controlSpeech = false

        } else {
          
            startRecording()
            microphoneButton.setTitle("Stop", for: .normal)
            microphoneButton.setImage(#imageLiteral(resourceName: "Stop"), for: .normal)
            self.controlSpeech = true
            
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
                /*
                self.detectedTextLabel.text = result?.bestTranscription.formattedString
               
 */
                
                if self.controlSpeech == false{
                    self.loadSpeechData(speechData: (result?.bestTranscription.formattedString)!)
                    isFinal = (result?.isFinal)!
                    print(isFinal)
                }
                
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func loadSpeechData(speechData: String) {
        var product = ""
        var result = speechData.components(separatedBy: " ")
        if result.count >= 2{
            
            for res in result{
                var x = 0
                var control = false
                while(x < Constants.ARRAYNUMBERS.count){
                    if Constants.ARRAYNUMBERS[x].numberLetter.lowercased() == res || Constants.ARRAYNUMBERS[x].numberLetter == res{
                        self.quantityProductTextField.text = Constants.ARRAYNUMBERS[x].number
                        control = true
                    }
                    x = x + 1
                }
                if control == false {
                     product += res + " "
                }
            }
            self.nameProductTextField.text = product
          
        }else{
         
            self.nameProductTextField.text = result[0]
            self.quantityProductTextField.text = "1"
            
        }
    }

    func printMessage(error:String){
        
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void  in
        }
        alert.addAction(accion)
        self.present(alert,animated:true,completion: nil)
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProductButton(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
