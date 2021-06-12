# agent_dart_example

## how to run example

1. use [create-ic-app](https://github.com/MioQuispe/create-ic-app) to bootstrap a local canister project
   
   Follow instructions here:
   [https://github.com/MioQuispe/create-ic-app#get-started](https://github.com/MioQuispe/create-ic-app#get-started)

   It will runs a example `counter` canister on your machine. 

2. dfx port is running randomly. You should be seeing that after you run:
    ```
    dfx start --background
    ```
    Usually, it is 5 digits integer. like `60916`

3. write down the counter(*NOT* front end assets) canister id:

    eg:
    ```bash
    Installing canisters...
    Creating UI canister on the local network.
    The UI canister on the "local" network is "r7inp-6aaaa-aaaaa-aaabq-cai" # <<< !NOT! this one
    Installing code for canister assets, with canister_id rrkah-fqaaa-aaaaa-aaaaq-cai # <<< !NOT! this one
    ...
    ...
    Installing code for canister counter, with canister_id ryjl3-tyaaa-aaaaa-aaaba-cai # <<< THIS IS CORRECT !!
    Deployed canisters.
    ```

4. go back to `agent_example`, change `lib/main.dart` 
   
    ```dart
        void initCounter() {
        _counter = AgentFactory.create(
                canisterId: "ryjl3-tyaaa-aaaaa-aaaba-cai", // << change this
                url: "http://localhost:60916", //<< change the port
                idl: idl
                )
            .hook(Counter());
        }
    ```

5. run flutter

   use android emulator or ios emulator to run

    ```bash
    flutter run
    ```

   if you want to run flutter on macos, please do the following:

    - first `flutter run -d macos`, it will build and run first.
    - Then you will came up with an error:
        ```
        SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)
        ```
   
    - Go to  file `DebugProfile.entitlements` and `ReleaseProfile.entitlements` under directory macos/Runner/, add the following:
        ```
        <key>com.apple.security.network.client</key>
        <true/>
        ```
    