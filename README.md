# MyContact

## Documentation
[API Documentation](http://172.25.14.32:803/swagger/ui/index#!/MemberController)

## Clean Derived Data
```shell
sudo rm -rf ~/Library/Developer/Xcode/DerivedData
```

## Get Started
```shell
pod cache clean --all;pod deintegrate;pod install --repo-update
```

## Before Commit
`shift` + `Command` + `K`
```shell
pod cache clean --all;pod deintegrate
```

## Open Project with Xcode
```shell
open MyContact.xcworkspace
```