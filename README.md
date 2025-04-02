
<p align="center">
  
  ![EPIC murder mystery](https://github.com/user-attachments/assets/c4b9a689-9a81-4176-87a8-02ab4766004f)
  
</p>


# EPIC! Murder Mystery

EPIC! Murder Mystery is a combination of multiple different Murder Mystery modes from other games, all added into SRB2, with help from a few devs (Jisk, luigi budd, Unmatched Bracket)

Our main inspiration is ROBLOX's Murder Mystery 2, and we aim to make the mode mostly similar to it.

[If you want a more simple, but unique project, check out **Leo's Murder Mystery**](https://github.com/LeonardoTheMutant/SRB2-Murder-Mystery)

This mode is 100% reusable.

## How to build it?

### OpenSUSE

Install the following dependencies:
```
sudo zypper in make nodejs nodejs-common npm
```

Clone the repository:

```
git clone --recursive https://github.com/Saxashitter/murder-mystery.git
```

Enter the PAK3 directory:

```
cd murder-mystery ; cd PaK3
```

Install PAK3 dependencies:

```
npm install
```

Go back to parent directory:

```
cd ..
```

Create 'build' directory:

```
mkdir -p build
```

Build the pk3:

```
make
```

Test the newly built pk3:

```
make runlinux
```

Build and test the newly built pk3:

```
make buildrunlinux
```

( You can also download the src, extract it, put it in your addons/ folder, and use the addfolder command to load it (ex. "addfolder addons/murder-mystery/src" )

## How can I help?
If you can code or do art, hit us up at our Discord server (linked below) or hit up one of the main devs!
**@epixgamer3333333** (1245610925793345579)
**@j1sk** (266392657884872715)

## Is there an Discord server?
Yes! https://discord.gg/J6yzyJV8Ta

You'll be pinged whenever our test server gets updated!
