//
//  ShareViewController.swift
//  Bring It!
//
//  Created by Administrador on 11/11/17.
//  Copyright © 2017 tec. All rights reserved.
//

import UIKit
import SearchTextField

class ShareViewController: UIViewController,UITextFieldDelegate {

    
    
    
    @IBOutlet weak var emailAutoCTextField: UITextField!
    var autoCompletionPossibilities = ["Red","Blue","Yellow"]
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailAutoCTextField.delegate = self
    
        // Do any additional setup after loading the view.
    }

   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //1
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        if subString.characters.count == 0 { // 3 when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString) //4
        }
        return true
    }
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.characters.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        emailAutoCTextField.text = ""
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring) //1
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.emailAutoCTextField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities { //2
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: userQuery.characters.count,length:autocompleteResult.characters.count))
        self.emailAutoCTextField.attributedText = colouredString
    }
    
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.emailAutoCTextField.position(from: self.emailAutoCTextField.beginningOfDocument, offset: userQuery.characters.count) {
            self.emailAutoCTextField.selectedTextRange = self.emailAutoCTextField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = emailAutoCTextField.selectedTextRange
        emailAutoCTextField.offset(from: emailAutoCTextField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.characters.count))
        autoCompleteCharacterCount = autoCompleteResult.characters.count
        return autoCompleteResult
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
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
