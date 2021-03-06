-- 
#define PKT_INPUT_EVENT 0x02
[PKT_INPUT_EVENT] = "M> Input event",
#define PKT_CURSOR_ENTER 0x03
[PKT_CURSOR_ENTER] = "M> Cursor enter",
#define PKT_CURSOR_ENTER_ACK 0x04
[PKT_CURSOR_ENTER_ACK] = "S> Cursor enter ACK",
#define PKT_SLAVE_CONFIG_REQUEST 0x05
[PKT_SLAVE_CONFIG_REQUEST] = "M> Slave config request?",
#define PKT_SLAVE_CONFIG_REPLY 0x06
[PKT_SLAVE_CONFIG_REPLY] = "S> Slave config reply?",
#define PKT_CURSOR_EXIT 0x07
[PKT_CURSOR_EXIT] = "S> Cursor exit",

#define PKT_CURSOR_SHORTCUT_RETURN 0x09
[PKT_CURSOR_SHORTCUT_RETURN] = "M> Cursor shortcut return",
#define PKT_SLAVE_CLIPBOARD_STATUS 0x0A
[PKT_SLAVE_CLIPBOARD_STATUS] = "S> Slave clipboard status",
#define PKT_INPUT_MIRROR 0x0B
[PKT_INPUT_MIRROR] = "M> Input Mirror",

#define PKT_SCREENSAVER_STATE 0x0F
[PKT_SCREENSAVER_STATE] = "M> Screensaver state",
#define PKT_LOCK_SLAVE 0x10
[PKT_LOCK_SLAVE] = "M> Lock slave",
#define PKT_SHUTDOWN_SLAVE 0x11
[PKT_SHUTDOWN_SLAVE] = "M> Shutdown slave",
#define PKT_MASTER_HEARTBEAT 0x12
[PKT_MASTER_HEARTBEAT] = "M> Master heartbeat",
#define PKT_SLAVE_CTRL_ALT_DEL 0x13
[PKT_SLAVE_CTRL_ALT_DEL] = "M> Slave Ctrl+Alt+Delete",
#define PKT_CONFIGURATION_UPDATE 0x14
[PKT_CONFIGURATION_UPDATE] = "M> Configuration update",
#define PKT_SOMETHING_WITH_CONFIG 0x15
[PKT_SOMETHING_WITH_CONFIG] = "RARE -- Something with config",
#define PKT_DISABLE_EDGE_TRANSITIONS 0x16
[PKT_DISABLE_EDGE_TRANSITIONS] = "M> Disable edge transitions",
#define PKT_SESSION_TERMINATION 0x17
[PKT_SESSION_TERMINATION] = "S> Session termination",
#define PKT_MULTIMON_EDGE_TRAVERSAL 0x18
[PKT_MULTIMON_EDGE_TRAVERSAL] = "S> Multi-monitor edge traversal",

#define PKT_ENCRYPTION_CONFIG_MISMATCH 0x19
[PKT_ENCRYPTION_CONFIG_MISMATCH] = "S> Encryption config mismatch",
#define PKT_SESSION_SETUP 0x1A
[PKT_SESSION_SETUP] = "M> Session setup",
#define PKT_SESSION_SETUP_ACK 0x1B
[PKT_SESSION_SETUP_ACK] = "S> Session Setup ACK",
#define PKT_SLAVE_ANNOUNCE 0x1C
[PKT_SLAVE_ANNOUNCE] = "S> Slave announce",
#define PKT_SLAVE_HEARTBEAT 0x1D
[PKT_SLAVE_HEARTBEAT] = "S> Slave heartbeat",
