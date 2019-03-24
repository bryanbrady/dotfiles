import Control.Applicative

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.Plane
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Config.Gnome (gnomeConfig)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.IM
import XMonad.Layout.Minimize
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ShowWName (showWName', SWNConfig(..))
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP, removeKeysP)
import XMonad.Util.Run(hPutStrLn, spawnPipe)

import Data.List (isInfixOf, isPrefixOf)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

myTerminal :: String
myTerminal = "gnome-terminal"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True 

myBorderWidth :: Dimension
myBorderWidth = 1

myWorkspaces = [ "1:web"
               , "2:work"
               , "3:email"
               , "4:music"
               , "5:IM"
               , "6:stats"
               , "7:extra"
               , "8:extra"
               , "9:extra"
               , "10:dev"
               , "11:dev"
               , "12:dev"
               ]

role = stringProperty "WM_WINDOW_ROLE"
name = stringProperty "WM_NAME"

isAgnClient = className =? "Agnclient"
isChrome = className =? "Google-chrome"
isEmacs = className =? "Emacs23"
isGvim = className =? "Gvim"
isNautilus= className =? "Nautilus"
isTerminal = className =? "Gnome-terminal"
isLauncher = isTerminal <&&> name =? "Launcher Terminal"
isHtopTerm = role =? "htop"
isPidginBuddyList = className =? "Pidgin" <&&> name =? "Buddy List"
isSametime = className =? "Sametime"
isLotusNotes = className =? "Lotus Notes"
isPandora = ("Pandora One" `isPrefixOf`) <$> name 
isGrooveshark = ("Grooveshark" `isPrefixOf`) <$> name 
isMusic = isPandora <||> isGrooveshark

myAdditionalKeysP = 
    [ ("M-S-q", spawn "gnome-session-quit")
    -- Launchers
    , ("M-g",   runOrRaise "google-chrome" isChrome)
    , ("M-S-g", spawn "google-chrome")
    , ("M-e",   runOrRaise "emacs" isEmacs)
    , ("M-S-e", spawn "emacs")
    , ("M-t",   runOrRaise "gnome-terminal" isTerminal)
    , ("M-S-t", spawn "gnome-terminal")
    , ("M-f",   runOrRaise "nautilus --no-desktop" isNautilus)
    , ("M-S-f", spawn "nautilus --no-desktop")
    , ("M-v",   runOrRaise "gvim" isGvim)
    , ("M-S-v", spawn "gvim")
    , ("M-z",   runOrRaise "/home/babrady/scripts/shell/launch_music_wwws" isMusic)
    , ("M-S-z",  spawn "/home/babrady/scripts/shell/launch_music_wwws")
    -- Search!
    , ("M-s", spawn "x-www-browser \"http://www.google.com/search?q=`xclip -o`\"")
    -- Workspace manipulation
    , ("M-<Page_Up>", prevWS)
    , ("M-<Page_Down>", nextWS)
    --, ("M-S-<Page_Up>", moveTo Prev EmptyWS)
    --, ("M-S-<Page_Down>", moveTo Next EmptyWS)
    , ("M-o", toggleWS)
    , ("M-d", withFocused $ windows . W.sink)
    , ("M-m", withFocused minimizeWindow)
    , ("M-S-m", sendMessage RestoreNextMinimizedWin)
    -- Window navigation
    -- Show Prompt to jump to window by name
    , ("M-w", windowPromptGoto myXPConfig)
    -- Show Prompt to bring window by name
    , ("M-b", windowPromptBring myXPConfig)
    -- Show Grid of open windows
    , ("M-S-w", goToSelected myGSConfig)
    -- Show Grid of open windows
    , ("M-S-b", bringSelected myGSConfig)
    ]
    ++
    -- move focus between physical screens. default mod-{w,e,r} are used by other mappings
    -- {w,e,r} -> {p,[,[}
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "p[]" [0..] 
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-")]
    ]

myAdditionalKeys = 
    M.toList (planeKeys mod1Mask (Lines 4) Finite)
    ++ 
    [((m .|. mod1Mask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces ([xK_1 .. xK_9] ++ [xK_0, xK_minus, xK_equal, xK_BackSpace])
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]

-- Configurations --------------------------------- 
-- show workspace name as it changes
mySwnConf = SWNC { swn_font = "xft:Ubuntu:size=48"
                 , swn_bgcolor = "black"
                 , swn_color = "green"
                 , swn_fade = 1
                 }

-- window prompts
myXPConfig = defaultXPConfig {
      autoComplete = Just 500000
    , font = "xft:Ubuntu:size=28"
    , height = 48
    , position = Top
    , searchPredicate = isInfixOf  -- new in 0.10
}

-- window grid
myGSConfig = defaultGSConfig {
      gs_cellheight = 150
    , gs_cellwidth = 350
    , gs_font = "xft:Ubuntu:size=14"
}
--------------------------------------------------

myLayoutHook = avoidStruts 
             $ minimize
             $ showWName' mySwnConf
             $ onWorkspace "1:web" webLayout
             $ onWorkspace "5:IM" imLayout 
             $ defaultLayout
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = 1/2
        delta = 3/100
        defaultLayout = tiled ||| Mirror tiled ||| Full
        -- 1:web
        webRatio = 1/3
        webTiled = Tall nmaster delta webRatio 
        webLayout = webTiled ||| Full
        -- IM layout
        isSametimeBuddyList = Title "IBM Lotus Sametime Connect - babrady@us.ibm.com "
        stLayout = withIM (1/9) isSametimeBuddyList defaultLayout
        imLayout = withIM (1/10) (Role "buddy_list")  stLayout


--myManageHook = composeAll(
--      -- ignores
--      [ className =? "Unity-2d-panel"              --> doIgnore
--      , className =? "IBM Lotus Sametime Connect " --> doIgnore 
--      -- floats
--      , className =? "Eodxc"             --> doFloat
--      , className =? "Unity-2d-launcher" --> doFloat
--      , name =? "Bug Information"        --> doFloat -- HDWB zcollect
--      -- email
--      , isLotusNotes                     --> doShift "3:email"
--      -- IM/ST/VPN/Launcher
--      , isAgnClient                      --> doShift "5:IM" 
--      , isPidginBuddyList                --> doShift "5:IM"
--      , isLauncher                       --> doShift "5:IM"
--      -- stats
--      , isHtopTerm                       --> doShift "6:stats"
--      -- music
--      , className =? "Gpodder"           --> doShift "4:music"
--      , manageHook gnomeConfig
--    ])

myManageHook = composeAll(
      -- ignores
      [ className =? "Unity-2d-panel"              --> doIgnore
      , className =? "IBM Lotus Sametime Connect " --> doIgnore 
      -- floats
      , className =? "Eodxc"             --> doFloat
      , className =? "Unity-2d-launcher" --> doFloat
      , name =? "Bug Information"        --> doFloat -- HDWB zcollect
      -- email
      , isLotusNotes                     --> doShift "3:email"
      -- IM/ST/VPN/Launcher
      , isAgnClient                      --> doShift "5:IM" 
      , isPidginBuddyList                --> doShift "5:IM"
      , isLauncher                       --> doShift "5:IM"
      -- stats
      , isHtopTerm                       --> doShift "6:stats"
      -- music
      , className =? "Gpodder"           --> doShift "4:music"
      , manageHook gnomeConfig
    ])

main = do
--xmproc <- spawnPipe "/usr/bin/xmobar /home/babrady/.xmobarrc"
xmonad $ gnomeConfig
    { terminal = myTerminal
    , focusFollowsMouse = myFocusFollowsMouse
    , borderWidth = myBorderWidth
    , workspaces = myWorkspaces
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
--    , logHook = dynamicLogWithPP $ xmobarPP
--                    { ppOutput = hPutStrLn xmproc
--                    , ppTitle = xmobarColor "green" "" . shorten 50
--                    }
    }
    `additionalKeysP` myAdditionalKeysP
    -- Navigate workspaces with Left, Right, Up, Down
    `additionalKeys` myAdditionalKeys


