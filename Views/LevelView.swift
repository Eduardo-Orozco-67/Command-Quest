import SwiftUI
import AVKit

struct LevelView: View {
    
    let level: Levelq
    @EnvironmentObject var navigation: NavigationManager
    @State private var userInput = ""
    @State private var output = ""
    @State private var levelCompleted = false
    @State private var commandHistory: [String] = []
    @State private var historyIndex: Int = 0
    @State private var failedAttempts = 0
    @FocusState private var isInputFocused: Bool
    @State var nav: Bool = false

    private let correctCommands: [Int: String] = [
        1: "ls",
        2: "cd documents",
        3: "touch level3.txt",
        4: "rm level3.txt",
        5: "cp example.txt backup.txt",
        6: "mv homework.txt completed/",
        7: "cat note.txt",
        8: "mkdir newfolder",
        9: "rmdir newfolder",
        10: "chmod 700 example.txt"
    ]
    
    private let commandOutputs: [Int: String] = [
        1: """
        Documents  Downloads  Music  Pictures  Videos  Desktop
        """,

        2: """
        XE03J@command-quest:~/Documents$ 
        """,

        3: """
        XE03J@command-quest:~/Documents$ touch level3.txt
        (No output, but the file was created)
        """,

        4: """
        XE03J@command-quest:~/Documents$ rm level3.txt
        file 'level3.txt' deleted
        """,

        5: """
        XE03J@command-quest:~/Documents$ cp example.txt backup.txt
        'example.txt' copied to 'backup.txt'
        """,

        6: """
        XE03J@command-quest:~/Documents$ mv homework.txt completed/
        'homework.txt' moved to 'completed/'
        """,

        7: """
        XE03J@command-quest:~/Documents$ cat note.txt
        This is a test note.
        """,

        8: """
        XE03J@command-quest:~/Documents$ mkdir newfolder
        Directory 'newfolder' created
        """,

        9: """
        XE03J@command-quest:~/Documents$ rmdir newfolder
        Folder 'newfolder' deleted
        """,

        10: """
        XE03J@command-quest:~/Documents$ chmod 700 example.txt
        Permissions for 'example.txt' updated
        """
    ]

    private let commandDocs: [String: String] = [
        "ls": """
        NAME:
            ls - List directory contents

        DESCRIPTION:
            Displays a list of files and folders in the current directory.

        USAGE:
            ls              → Shows files in the current folder.
            ls -l           → Displays a detailed list with file permissions, sizes, and modification dates.
            ls -a           → Includes hidden files (those starting with a dot '.').
        """,

        "cd": """
        NAME:
            cd - Change directory

        DESCRIPTION:
            Moves to a different folder (directory).

        USAGE:
            cd [directory]  → Changes to the specified directory.
            cd Documents    → Moves to the 'Documents' folder.
            cd ..           → Moves up one level (to the parent directory).
            cd ~            → Moves to the home directory.
        """,

        "touch": """
        NAME:
            touch - Create an empty file or update its timestamp

        DESCRIPTION:
            Creates a new empty file or updates the last modified time of an existing file.

        USAGE:
            touch [filename]      → Creates an empty file.
            touch example.txt     → Creates 'example.txt' if it doesn’t exist.
            touch file1 file2     → Creates multiple files at once.
        """,

        "rm": """
        NAME:
            rm - Remove (delete) files

        DESCRIPTION:
            Deletes files permanently. Be careful—there's no undo!

        USAGE:
            rm [filename]         → Deletes the specified file.
            rm example.txt        → Deletes 'example.txt'.
            rm -r folder_name     → Deletes a folder and all its contents (use with caution!).
            rm -i file.txt        → Asks for confirmation before deleting.
        """,

        "cp": """
        NAME:
            cp - Copy files

        DESCRIPTION:
            Creates a duplicate of a file or folder.

        USAGE:
            cp [source] [destination]  → Copies a file to a new location.
            cp file1.txt backup.txt    → Copies 'file1.txt' to 'backup.txt'.
            cp -r folder1 folder2      → Copies an entire folder and its contents.
        """,

        "mv": """
        NAME:
            mv - Move or rename files

        DESCRIPTION:
            Moves a file to a different location or renames it.

        USAGE:
            mv [source] [destination]  → Moves or renames a file.
            mv oldname.txt newname.txt → Renames 'oldname.txt' to 'newname.txt'.
            mv file.txt Documents/     → Moves 'file.txt' into the 'Documents' folder.
        """,

        "cat": """
        NAME:
            cat - Display the contents of a file

        DESCRIPTION:
            Shows the content of a file directly in the terminal.

        USAGE:
            cat [filename]       → Displays the file's content.
            cat example.txt      → Prints the contents of 'example.txt'.
            cat file1 file2      → Combines and displays multiple files.
        """,

        "mkdir": """
        NAME:
            mkdir - Create a new directory

        DESCRIPTION:
            Creates a new folder (directory).

        USAGE:
            mkdir [directory_name]  → Creates a new folder.
            mkdir NewFolder         → Creates a folder named 'NewFolder'.
            mkdir -p dir1/dir2      → Creates nested directories if they don’t exist.
        """,

        "rmdir": """
        NAME:
            rmdir - Remove an empty directory

        DESCRIPTION:
            Deletes an empty folder. If the folder contains files, use 'rm -r' instead.

        USAGE:
            rmdir [directory_name]  → Removes an empty folder.
            rmdir NewFolder         → Deletes 'NewFolder' if it is empty.
        """,

        "chmod": """
        NAME:
            chmod - Change file permissions

        DESCRIPTION:
            Modifies who can read, write, or execute a file.

        USAGE:
            chmod [permissions] [filename]  → Changes file permissions.

        COMMON EXAMPLES:
            chmod 700 file.txt  → Only the owner can read, write, and execute.
            chmod 644 file.txt  → Owner can write; everyone else can only read.
            chmod +x script.sh  → Makes 'script.sh' executable.

        PERMISSION CODES:
            7 = Read (4) + Write (2) + Execute (1) [Full control]
            6 = Read (4) + Write (2) [No execute]
            4 = Read only
            0 = No permissions
        """,
        
        "man": "📖 Learn about the 'man' command... with 'man' itself!",
    ]

    private let easterEggs: [String: String] = [
        "sudo rm -rf /": "🚨 Permission denied! Nice try, but I'm not letting you destroy the system. 😈",
        "cd /dev/null": "🕳️ Welcome to the void. Everything you put here disappears forever!",
        "alias ls='echo Nope!'": "🙅‍♂️ Listing files? Not anymore! (To reset, restart your terminal).",
        "history -c": "🧠 Memory wiped! Did you just erase your past?",
        "mv ~/dev/null": "😱 You just moved your home folder to the abyss!",
        "chmod -R 000 /": "🔒 Congratulations! You just locked yourself out of your entire system. Well played.",
        "wget https://malware.example.com": "⚠️ Warning! Downloading suspicious files is a bad idea.",
        "shutdown -h now": "💤 System shutting dow— Just kidding! But be careful with this one.",
        "rm -rf --no-preserve-root /": "🔥 The ultimate disaster command. Lucky for you, it won’t run here!",
        "whoami": "🕵️ You are... the ruler of this terminal!",
        "date": "📆 Today's date and time: $(date)",
        "cal": "📅 Here’s the current month’s calendar!",
        "uptime": "⏳ Your computer has been awake for a while now...",
        "history": "📜 A list of all the mistakes—I mean, commands—you’ve made.",
        "sleep 3": "⏰ Taking a short break... Zzz...",
        "ls -a": "🔍 Listing hidden files... What secrets does your terminal hold?"
    ]
    
    private let hints: [Int: [String]] = [
        1: [
            "💡 Hint 1: This command helps you see what’s inside a folder.",
            "💡 Hint 2: It’s a very short command, just two letters.",
            "💡 Hint 3: It’s commonly used to check what files exist.",
            "💡 Hint 4: It starts with 'l'."
        ],
        2: [
            "💡 Hint 1: You need to change directories.",
            "💡 Hint 2: The command means 'change directory'.",
            "💡 Hint 3: The command starts with 'c'.",
            "💡 Hint 4: It's often followed by a folder name."
        ],
        3: [
            "💡 Hint 1: You need to create a file.",
            "💡 Hint 2: The command is used to update timestamps too.",
            "💡 Hint 3: It starts with 't'.",
            "💡 Hint 4: It's a five-letter command."
        ],
        4: [
            "💡 Hint 1: You need to delete a file.",
            "💡 Hint 2: The command starts with 'r'.",
            "💡 Hint 3: Be careful! This command is powerful.",
            "💡 Hint 4: It has only two letters."
        ],
        5: [
            "💡 Hint 1: You need to duplicate a file.",
            "💡 Hint 2: This command starts with 'c'.",
            "💡 Hint 3: It’s used to make an exact copy of a file.",
            "💡 Hint 4: It's a two-letter command."
        ],
        6: [
            "💡 Hint 1: You need to move a file to another folder.",
            "💡 Hint 2: This command is also used to rename files.",
            "💡 Hint 3: It starts with 'm'.",
            "💡 Hint 4: It's a two-letter command."
        ],
        7: [
            "💡 Hint 1: You need to display a file’s content.",
            "💡 Hint 2: The command means 'concatenate'.",
            "💡 Hint 3: It starts with 'c'.",
            "💡 Hint 4: It’s a three-letter command."
        ],
        8: [
            "💡 Hint 1: You need to create a new folder.",
            "💡 Hint 2: The command starts with 'm'.",
            "💡 Hint 3: It’s often followed by a folder name.",
            "💡 Hint 4: It’s a five-letter command."
        ],
        9: [
            "💡 Hint 1: You need to delete a folder.",
            "💡 Hint 2: This command only works on empty folders.",
            "💡 Hint 3: It starts with 'r'.",
            "💡 Hint 4: It’s a five-letter command."
        ],
        10: [
            "💡 Hint 1: You need to change file permissions.",
            "💡 Hint 2: The command starts with 'ch'.",
            "💡 Hint 3: It allows setting read, write, and execute rights.",
            "💡 Hint 4: It’s a five-letter command."
        ]
    ]

    var body: some View {
           ZStack {
               Color(hex: "#0D0D0D").ignoresSafeArea()
                   .overlay(
                       Color(hex: "#5C2D91").opacity(0.15         )
                           .blur(radius: 50)
                           .edgesIgnoringSafeArea(.all)
                   )

               if level.number == 0 {
                   ArithmeticEx1View()
               } else {
                   VStack {
                       Text("LEVEL \(level.number)")
                           .font(.largeTitle)
                           .bold()
                           .foregroundColor(Color(hex: "#78FF00"))
                           .padding(.top, 10)
                       
                       ZStack {
                           RoundedRectangle(cornerRadius: 30)
                               .fill(Color(hex: "#1A1A1A"))
                               .shadow(color: Color(hex: "#78FF00").opacity(0.5), radius: 8, x: 0, y: 0)
                           
                           VStack(alignment: .leading, spacing: 3) {
                               ScrollView {
                                   Text(output)
                                       .foregroundColor(Color(hex: "#00E6FF"))
                                       .font(.system(size: 28, design: .monospaced))
                                       .padding()
                                       .frame(maxWidth: .infinity, alignment: .leading)
                               }
                               
                               HStack {
                                   Text("XE03J@command-Quest:~$")
                                       .foregroundColor(Color(hex: "#78FF00"))
                                       .font(.system(size: 28, design: .monospaced))
                                   
                                   TextField("", text: $userInput)
                                       .foregroundColor(Color(hex: "#78FF00"))
                                       .font(.system(size: 28, design: .monospaced))
                                       .autocapitalization(.none)
                                       .disableAutocorrection(true)
                                       .focused($isInputFocused)
                                       .submitLabel(.go)
                                       .onSubmit { executeCommand() }
                               }
                               .padding(.horizontal, 15)
                           }
                           .padding(20)
                           .background(Color(hex: "#0D0D0D").opacity(0.9))
                           .cornerRadius(8)
                           .shadow(color: Color(hex: "#78FF00").opacity(0.4), radius: 5, x: 0, y: 0)
                       }
                       .padding(.horizontal, 40)
                       
                       if levelCompleted {
                           Button(action: { navigation.goBack() }) {
                               Text("Back to Levels")
                                   .font(.title2)
                                   .padding()
                                   .background(Color(hex: "#6400E4"))
                                   .foregroundColor(.black)
                                   .cornerRadius(8)
                           }
                           .padding(.top, 20)
                       }

                   }
               }
               if levelCompleted && level.number == 10 {
                       SuccessDialog(nav: $nav)
                           .frame(width: 715, height: 115)
                           .background(Color(hex: "#0D0D0D").ignoresSafeArea()
                            .overlay(
                                Color(hex: "#5C2D91").opacity(0.15         )
                                    .blur(radius: 50)
                                    .edgesIgnoringSafeArea(.all)
                            ))
                           .cornerRadius(50)
                           .shadow(radius: 10)
                           .zIndex(2) // Asegura que esté sobre otros elementos
                   }
           }
           .navigationBarBackButtonHidden(true)
           .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                   Button(action: {
                       navigation.goBack()
                   }) {
                       HStack {
                           Image(systemName: "chevron.left")
                           Text("Return to Menu")
                       }
                       .font(.title3)
                       .foregroundColor(Color(hex: "#78FF00"))
                   }
               }
           }
           .overlay(
               VStack {
                   
                   ProgressView(value: Double(level.number) / 10.0)
                       .progressViewStyle(LinearProgressViewStyle())
                       .accentColor(Color(hex: "#FF00FF"))
                       .padding(.horizontal, 20)
               }, alignment: .top
           )
           .onAppear {
               output = "Welcome to Command Quest!\n\nXE03J@command-Quest-Virtual-Platform:~$\n\n\(levelInstructions())"
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   isInputFocused = true
               }
           }
    }

    private func executeCommand() {
        let trimmedCommand = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        output += "\nXE03J@command-quest:~$ \(userInput)"

        commandHistory.append(trimmedCommand)
        historyIndex = commandHistory.count

        if trimmedCommand == "clear" {
            output = "Welcome to Command Quest!\n\nXE03J@command-Quest-Virtual-Platform:~$\n\n\(levelInstructions())"
        } else if trimmedCommand == correctCommands[level.number] {
            output += "\n" + (commandOutputs[level.number] ?? "")
            output += "\n✅ Well done! Level \(level.number) complete."
            levelCompleted = true
        } else if trimmedCommand.starts(with: "man ") {
            let command = trimmedCommand.replacingOccurrences(of: "man ", with: "")
            output += "\n📄 \(commandDocs[command] ?? "No manual entry for \(command)")"
        } else if let response = easterEggs[trimmedCommand] {
            output += "\n🥚 \(response)"
        } else {
            failedAttempts += 1
            _ = suggestCommand(for: trimmedCommand)
            output += "\n❌ Incorrect command."

            // Mostrar pistas progresivas hasta el 4to intento
            if failedAttempts <= 4, let hintList = hints[level.number], failedAttempts - 1 < hintList.count {
                output += "\n\(hintList[failedAttempts - 1])"
            }
            
            // Al quinto intento, sugerir automáticamente el comando 'man' correcto
            if failedAttempts == 5 {
                if let correctCommand = correctCommands[level.number]?.components(separatedBy: " ").first {
                    output += "\n💡 You seem stuck! Try using: `man \(correctCommand)` for help."
                }
            }
        }
        userInput = ""
    }

    private func suggestCommand(for input: String) -> String {
        let knownCommands = Array(correctCommands.values) + Array(commandDocs.keys)
        if let closest = knownCommands.min(by: { $0.levenshteinDistance(to: input) < $1.levenshteinDistance(to: input) }) {
            return "Did you mean '\(closest)'?"
        }
        return "Try again."
    }

    private func levelInstructions() -> String {
        switch level.number {
        case 1:
            return "Level 1: You need to see what files and folders exist in the current directory.\nThink about how you can list them using a terminal command."

        case 2:
            return "Level 2: Move into the 'Documents' directory.\nWhich command allows you to navigate between folders?"

        case 3:
            return "Level 3: Create an empty file named 'level3.txt'.\nWhat command would you use to generate a new file in the terminal?"

        case 4:
            return "Level 4: Remove the file 'level3.txt'.\nHow can you delete a file from the terminal?"

        case 5:
            return "Level 5: Make a backup of 'example.txt' by creating a duplicate named 'backup.txt'.\nWhich command allows you to copy files?"

        case 6:
            return "Level 6: Move the file 'homework.txt' into the 'completed/' folder.\nWhat command lets you change a file’s location?"

        case 7:
            return "Level 7: Display the content of 'note.txt' directly in the terminal.\nHow can you read a file without opening a text editor?"

        case 8:
            return "Level 8: Create a new folder called 'newfolder'.\nWhich command allows you to create directories?"

        case 9:
            return "Level 9: Delete the directory 'newfolder' (only if it is empty).\nWhat command is used to remove empty folders?"

        case 10:
            return "Level 10: Modify the permissions of 'example.txt' so that only you (the owner) can read, write, and execute it.\nWhat combination of permissions achieves this?"

        default:
            return "Unknown Level"
        }
    }

}

extension String {
    func levenshteinDistance(to target: String) -> Int {
        // 🔹 Si uno de los dos está vacío, devolver la longitud del otro
        if self.isEmpty { return target.count }
        if target.isEmpty { return self.count }

        let (s, t) = (Array(self), Array(target))
        var dp = [[Int]](repeating: [Int](repeating: 0, count: t.count + 1), count: s.count + 1)

        // Inicializar las primeras filas y columnas
        for i in 0...s.count { dp[i][0] = i }
        for j in 0...t.count { dp[0][j] = j }

        // Calcular la distancia
        for i in 1...s.count {
            for j in 1...t.count {
                if s[i - 1] == t[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1] // No hay costo si los caracteres son iguales
                } else {
                    dp[i][j] = Swift.min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]) + 1
                }
            }
        }
        return dp[s.count][t.count]
    }
}
    
struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView(level: Levelq(number: 1, command: "ls")).environmentObject(NavigationManager())
    }
}

//-----------------juego de estrellas--------------------------//

class SharedData: ObservableObject {
    @Published var resultValue: Bool = false
}

extension Color{
    public static let starFont: Color = Color(hex: "#5C2D91")
    public static let starsColor: Color = Color(hex: "#78FF00")
}

struct ArithmeticEx1View: View {
    
    @State private var stars: [Starrr] = []
    @State private var completed = false
    @State var nav: Bool = false
    @State private var showInstructions = true //Controls when to show instructions
    @State private var dialogOpacity = 1.0
    @State private var currentContentIndex = 0
    
    let unixCommands = [
        "ls", "cd", "pwd", "mkdir", "rm", "mv", "cp", "touch", "chmod", "chown",
        "echo", "cat", "nano", "vim", "grep", "find", "sed", "whoami", "tar", "zip",
        "unzip", "df", "du", "ps", "top", "kill", "ping", "curl", "wget", "man"
    ]
    
    let fakeCommands = [
        "lst", "pwwd", "echho", "delr", "mkdirr", "filex", "dirlst", "findit", "killprox", "netlin",
        "permfix", "sylogx", "superls", "xpt", "grapex", "ldr", "tarbx", "mvit", "runit",
        "cmx", "sdir", "updm", "logr", "staz", "bshn"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let columns = max(isLandscape ? 7 : 5, 1)
            let rows = max(isLandscape ? 5 : 7, 1)
            let starSize = max(min(geometry.size.width / CGFloat(columns) * 0.9, geometry.size.height / CGFloat(rows) * 0.8), 40)
            
            ZStack {
                Color(hex: "#0D0D0D").ignoresSafeArea()
                    .overlay(
                        Color(hex: "#5C2D91").opacity(0.15)
                            .blur(radius: 50)
                            .edgesIgnoringSafeArea(.all)
                    )
                if showInstructions {
                                StarsDialogExpandable(
                                    currentContentIndex: $currentContentIndex,
                                    dialogOpacity: $dialogOpacity
                                )
                                .transition(.opacity)
                                .onChange(of: dialogOpacity) { newValue in
                                    if newValue == 0 {
                                        withAnimation {
                                            showInstructions = false
                                        }
                                    }
                                }
                } else {
                    VStack {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: columns), spacing: 10) {
                            ForEach(stars, id: \ .id) { star in
                                Button(action: {
                                    guard !completed else { return }
                                    if star.isValidCommand {
                                        withAnimation {
                                            if let index = stars.firstIndex(where: { $0.id == star.id }) {
                                                stars[index].isFadingOut = true
                                                stars[index].isGrayedOut = true
                                                checkCompletion()
                                            }
                                        }
                                    } else {
                                        withAnimation {
                                            resetStars()
                                        }
                                    }
                                }) {
                                    ZStack {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: starSize))
                                            .foregroundColor(star.isGrayedOut ? .gray : .starsColor)
                                            .shadow(color: star.isGrayedOut ? .gray : .starsColor, radius: 5, x: 0.0, y: 0.0)
                                        
                                        Text(star.command)
                                            .font(.custom("Montserrat", size: starSize * 0.2))
                                            .bold()
                                            .foregroundColor(star.isGrayedOut ? .gray : .starFont)
                                            .padding(.top, 1)
                                    }
                                    .scaleEffect(star.isFadingOut ? 0.5 : 1.0)
                                    .opacity(star.isFadingOut ? 0.5 : 1.0)
                                }
                                .frame(width: starSize, height: 135)
                                .disabled(completed)
                            }
                        }
                        .drawingGroup()
                        .zIndex(0)
                        
                    }
                    .onAppear {
                        startGame()
                    }
                    if completed {
                        SuccessDialog(nav: $nav)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // 🔹 Asegura que esté centrado
                            .zIndex(2) // 🔹 Asegura que esté sobre otros elementos
                    }
                }
            }
            
        }
    }

    func startGame() {
        generateStars()
    }
    
    func generateStars() {
        stars.removeAll()
        var allStars = [Starrr]()
        var commandIndex = 0
        var isNextCommandValid = true
        
        let isLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        let columns = isLandscape ? 7 : 5
        let rows = isLandscape ? 5 : 7
        let totalStars = rows * columns

        while allStars.count < totalStars {
            var command: String

            if isNextCommandValid {
                if commandIndex < unixCommands.count {
                    command = unixCommands[commandIndex]
                    commandIndex += 1
                } else {
                    command = fakeCommands.randomElement() ?? "unknown"
                }
            } else {
                command = fakeCommands.randomElement() ?? "unknown"
            }

            let newStar = Starrr(isValidCommand: isNextCommandValid, command: command)
            allStars.append(newStar)
            isNextCommandValid.toggle()
        }

        stars = allStars.shuffled()
    }

    func checkCompletion() {
        if stars.filter({ $0.isValidCommand && !$0.isFadingOut }).isEmpty {
            completed = true
        }
    }

    func resetStars() {
        for index in stars.indices {
            stars[index].isFadingOut = false
            stars[index].isGrayedOut = false
        }
    }
}

struct ArithmeticEx1View_Previews: PreviewProvider {
    static var previews: some View {
        ArithmeticEx1View()
    }
}

struct Starrr: Identifiable {
    var id = UUID()
    var isValidCommand: Bool
    var command: String
    var isFadingOut: Bool = false
    var isGrayedOut: Bool = false
}
