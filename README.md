# Saxa's Murder Mystery

Saxa's Murder Mystery is a combination of multiple different Murder Mystery modes from other games, all added into SRB2, with help from a few devs (Jisk, luigi budd, Unmatched Bracket)

Our main inspiration is ROBLOX's Murder Mystery 2, and we aim to make the mode mostly similar to it.

[If you want a more simple, but unique project. Check out **Leo's Murder Mystery**](https://github.com/LeonardoTheMutant/SRB2-Murder-Mystery)

This mode is 100% re-usable.

## How to build it?

### OpenSUSE

Install the following dependencies:
```
sudo zypper in make nodejs-common
```

Clone the repository:

```
git clone --recursive https://github.com/vyvir/ravager
```

Enter the PAK3 directory:

```
cd ravager ; cd PaK3
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

## How can I help?
If you can code, try making a pull request for something you want!
If you can do art, compose, etc. Hit me up at **@literally_mario on Discord!**

## Is there an Discord server?
Yes! https://discord.gg/J6yzyJV8Ta

You'll be pinged whenever I'm hosting the mod, you can also contribute directly, and more!
