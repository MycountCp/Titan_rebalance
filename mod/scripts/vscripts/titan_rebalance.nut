untyped

global function Titan_ReBalance_Init                 //让该常量全局调用（global是指全局调用）

const int PAS_VANGUARD_DOOM_REGEN_ON_HIT = 120       // 用于控制回复量的常量
const int PAS_RONIN_SWORDCORE_REGEN_ON_HIT = 750     // 用于控制回复量的常量
const float PAS_VANGUARD_DOOM_EXTRA_CORE_SCALE = 5.0 // 基于原本1.0倍的受伤核心值，将额外增加这些
const bool HIDE_PLAYER_MAIN_HUD = false              // 用于判断是否启用移除UI的常量
const bool TITAN_REBALANCE_LOADOUT = false           // 用于判断泰坦平衡是否启用的常量
const bool TITAN_AEGIS_UPGRADE = false             
const bool HIGHLIGHTED_UID = true                    // 用于判断是否启用泰坦轮廓高亮的常量
const array<string> HIGHLIGHTED_UIDS =               // 用于存储玩家uid的常量（用于给予特定玩家泰坦轮廓高亮）
[
    ""
]

void function Titan_ReBalance_Init()
{
    AddCallback_OnTitanGetsNewTitanLoadout( Titan_ReBalance )   //声明泰坦平衡的函数
    //if ( TITAN_REBALANCE_LOADOUT )       //如果泰坦平衡启用，则启用下列的函数
    //{
        //AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_xo16_vanguard, OnMonarchXO16DamageTarget ) //声明适者生存帝王黄血后回盾的函数
        //AddDamageCallbackSourceID( eDamageSourceId.mp_titancore_shift_core, RoninSwordDamageTarget )  //声明高地战士浪人开核心后伤害回盾的函数
        //AddCallback_OnTitanDoomed( OnTitanEnterDoomedState )
        //AddCallback_OnTitanDoomed( OnTitanDoomed )  //声明浪人瞬间反应时自动使用相位时间的函数
    //}

    if ( HIDE_PLAYER_MAIN_HUD )  //声明移除UI的函数
        TryHideMainHudLifeLong()

    //if ( HIGHLIGHTED_UID )  //声明泰坦轮廓高亮的函数
        //HighlightCertainPlayer()
    AddCallback_OnPlayerRespawned( OnPlayerRespawned )  //声明用于给予泰坦特效的重生检测函数
}

void function Titan_ReBalance( entity titan, TitanLoadoutDef loadout )
{
    entity soul = titan.GetTitanSoul()
    if ( !IsValid( soul ) )
        return
    string characterName = GetTitanCharacterName( soul.GetTitan() )
    switch( characterName )
    {
        //case "scorch":
            //entity weapon = titan.GetMainWeapons()[0] // 获取烈焰主武器
            //weapon.AddMod( "fd_wpn_upgrade_1" ) // 为烈焰主武器子弹数+1
            //weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() ) // 更新弹夹
            //break

        case "ronin":
            GivePassive( soul, ePassives.PAS_ANTI_RODEO ) // 为浪人添加双烟
            //entity weapon = titan.GetOffhandWeapon( OFFHAND_ANTIRODEO ) // 获取相位冲刺
            //weapon.AddMod( "fd_phase_charges" ) // 为浪人添加双相位
            if ( SoulHasPassive( soul, ePassives.PAS_HYPER_CORE ) )
            {
            entity smokeWeapon =  titan.GetOffhandWeapon( OFFHAND_INVENTORY )  //如果泰坦装备超级核心配件
            if ( IsValid( smokeWeapon ) )
               smokeWeapon.SetWeaponPrimaryAmmoCount( smokeWeapon.GetWeaponPrimaryAmmoCount() + 1 )  //则电子烟获取数量+1
            }
            break
    }
       //foreach ( passive, value in soul.passives )
	//{
		//if ( !value )
			//continue

		//switch ( passive )
		//{
           // case ePassives.PAS_RONIN_AUTOSHIFT: // 剑封
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_SPECIAL ) // 获取剑封
                //weapon.AddMod( "fd_sword_block" ) // 为剑封新增配件（神盾升级，剑封受击获取核心）
               // break

            // case ePassives.PAS_TONE_SONAR: // 声纳回波
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_ANTIRODEO ) // 获取声纳回波
                //weapon.AddMod( "fd_sonar_duration" ) // 为声纳回波新增配件（神盾升级，增加声纳持续时间）
               // weapon.AddMod( "fd_sonar_damage_amp" ) // 为声纳回波新增配件（神盾升级，被声纳扫中的敌人获得易伤）
               // break

            // case ePassives.PAS_SCORCH_FIREWALL: // 增强火力
                //entity weapon = titan.GetOffhandWeapon( OFFHAND_ANTIRODEO ) // 获取增强火力
               // weapon.AddMod( "fd_explosive_barrel" ) // 为增强火力新增配件（神盾升级，爆炸桶）
               // break

            // case ePassives.pas_tone_burst: // 三连发
                //entity weapon = titan.GetOffhandWeapon( OFFHAND_ANTIRODEO ) // 获取三连发
               // weapon.AddMod( "pas_tone_burst_balanced" ) // 为三连发新增配件（零蓄力）
               // break

            // case ePassives.pas_legion_spinup: // 轻合金
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_SPECIAL ) // 获取轻合金
                //weapon.AddMod( "pas_legion_spinup_balanced" ) // 为轻合金新增配件（配件调整）
               // break

            // case ePassives.pas_ion_weapon_ads: // 折射棱镜
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_SPECIAL ) // 获取折射棱镜
                //weapon.AddMod( "pas_ion_weapon_ads_balanced" ) // 为折射棱镜新增配件（配件调整）
               // break

            // case ePassives.pas_scorch_firewall: // 火墙
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_SPECIAL ) // 获取火墙
                //weapon.AddMod( "pas_scorch_firewall_balanced" ) // 为火墙新增配件（配件调整）
               // break

            // case ePassives.pas_vanguard_rearm: // 帝王再武装
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_SPECIAL ) // 获取再武装
                //weapon.AddMod( "pas_vanguard_rearm_balanced" ) // 为再武装新增配件（配件调整）
               // break

            // case ePassives.pas_ion_tripwire: // 激光绊线
               // entity weapon = titan.GetOffhandWeapon( OFFHAND_SPECIAL ) // 获取激光绊线
                //weapon.AddMod( "pas_ion_tripwire_balanced" ) // 为激光绊线新增配件（配件调整）
               // break
		//}
	//}
}

//void function OnMonarchXO16DamageTarget( entity victim, var damageInfo ) //适者生存帝王黄血后回盾
//{
   // entity attacker = DamageInfo_GetAttacker( damageInfo ) // 获取本次伤害的攻击者
   // if ( !IsValid( attacker ) ) // 攻击者不可用--可能是开火后退出了游戏，需要检查来防止崩溃
       // return
   // if ( !attacker.IsPlayer() ) // 攻击者不是玩家
       // return

    //entity soul = attacker.GetTitanSoul()
   // if ( !IsValid( soul ) ) // 攻击者的titansoul不可用
       // return
    //if ( !soul.IsDoomed( ) ) // 泰坦并未黄血
       // return

    //if ( !SoulHasPassive( soul, ePassives.PAS_VANGUARD_DOOM ) ) // titansoul并没有适者生存
        //return

    // 检查全部完成，下面是回盾逻辑
    //int newShieldHealth = minint( soul.GetShieldHealthMax(), soul.GetShieldHealth() + PAS_VANGUARD_DOOM_REGEN_ON_HIT )
    //soul.SetShieldHealth( newShieldHealth )
    // minint: 获取其参数内的最小值。这里意思为：若恢复后的盾值大于最大盾值，则选用最大盾值，以防止崩溃
//}


//void function RoninSwordDamageTarget( entity victim, var damageInfo )//高地战士浪人开核心后伤害回盾
//{
    //entity attacker = DamageInfo_GetAttacker( damageInfo ) // 获取本次伤害的攻击者
    //if ( !IsValid( attacker ) ) // 攻击者不可用--可能是开火后退出了游戏，需要检查来防止崩溃
        //return
    //if ( !attacker.IsPlayer() ) // 攻击者不是玩家
        //return

    //entity soul = attacker.GetTitanSoul()
   // if ( !IsValid( soul ) ) // 攻击者的titansoul不可用
        //return

    //if ( !SoulHasPassive( soul, ePassives.PAS_RONIN_SWORDCORE ) ) // titansoul并没有高地战士
        //return

    // 检查全部完成，下面是回盾逻辑
    //int newShieldHealth = minint( soul.GetShieldHealthMax(), soul.GetShieldHealth() + PAS_RONIN_SWORDCORE_REGEN_ON_HIT )
    //soul.SetShieldHealth( newShieldHealth )
    // minint: 获取其参数内的最小值。这里意思为：若恢复后的盾值大于最大盾值，则选用最大盾值，以防止崩溃
//}

//void function  OnTitanEnterDoomedState( entity victim, var damageInfo )
//{
    //entity soul = victim.GetTitanSoul()
    //if ( !IsValid( soul ) ) // 受伤者的titansoul不可用
        //return
    //if ( !SoulHasPassive( soul, ePassives.PAS_VANGUARD_DOOM ) ) // titansoul并没有适者生存
        //return
    //if ( IsValid( soul ) )
    //{
        //if ( !( "enteredDoom" in soul.s ) )
            //soul.s.enteredDoom <- true
    //}

    //soul.SetShieldHealthMax( 8000 ) //变更黄血后帝王的盾条上限为8000
//}

//void function OnPlayerPostDamaged( entity victim, var damageInfo )
//{
    //TryAddExtraCoreMeterForPasVanguardDoom( victim, damageInfo )
//}

// 这是DB的个人习惯：Try开头的函数用来表示进行尝试，当成功时返回true，反之返回false
//bool function TryAddExtraCoreMeterForPasVanguardDoom( entity victim, var damageInfo )  //用于调整黄血状态的适者生存帝王受伤所获取的核心值
//{
    //if ( !IsValid( victim ) )
        //return false

    //if ( !victim.IsTitan() )  //检查是否是泰坦
        //return false
    //entity soul = victim.GetTitanSoul()
    //if ( !IsValid( soul ) )
        //return false
    //if ( !( "enteredDoom" in soul.s ) || !soul.s.enteredDoom ) // 判断帝王是否激活被动
        //return false
    //if ( !SoulHasPassive( soul, ePassives.PAS_VANGUARD_DOOM ) ) // 判断帝王是否有适者生存
        //return false

    //float damage = DamageInfo_GetDamage( damageInfo ) * PAS_VANGUARD_DOOM_EXTRA_CORE_SCALE
    //AddCreditToTitanCoreBuilderForTitanDamageReceived( victim, damage )
        //return true // 额外核心值应用成功，返回true

//}

//void function OnTitanDoomed( entity titan, var damageInfo )  //调整浪人瞬间反应黄血时的相位时间
//{

	//if ( !IsAlive( titan ) )  //检查是否是泰坦
		//return

	//entity soul = titan.GetTitanSoul()

	//if ( titan.IsPlayer() )  //检查是否是玩家
	//{
		//if ( SoulHasPassive( soul, ePassives.PAS_RONIN_AUTOSHIFT ) ) // 浪人瞬间反应时间调整
			//PhaseShift( titan, 0, 1.0 )
	//}
//}

void function TryHideMainHudLifeLong()  //判断该函数是否启用
{
    thread TryHideMainHudLifeLong_Threaded()  //若该函数启用则启用这个Threaded函数
}

void function TryHideMainHudLifeLong_Threaded() //移除全部UI（保留血条）
{
    while ( true )
    {
        foreach ( entity player in GetPlayerArray() )
        {
            if ( !HasCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD ) )
                AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD )  //CE_FLAG_TITAN_3P_CAM将会连同自己的血条一并隐藏
        }
        WaitFrame()
    }
}

//void function HighlightCertainPlayer()  //判断该函数是否启用
//{
    //thread HighlightCertainPlayer_Threaded()  //若该函数启用则启用这个Threaded函数
//}

//void function callbackFunc() //让指定uid玩家驾驶的泰坦轮廓发光
//{
    //while ( true )
    //{
        //WaitFrame()
        //foreach ( entity player in GetPlayerArray_Alive() )
        //{
            //if ( HIGHLIGHTED_UIDS.contains( player.GetUID() ) )
                //Highlight_SetEnemyHighlight( player, "enemy_boss_bounty" )  //用于战役boss的发光特效  //enemy_sonar是用于声纳的发光特效
        //}
    //}
//}

void function OnPlayerRespawned( entity player )
{
    if ( HIGHLIGHTED_UIDS.contains( player.GetUID() ) )
        thread RGB_Highlight( player, true, true )            //( player, true)则为特效不穿墙
}   