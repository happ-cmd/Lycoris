# Deepwoken Rewrite
**Module diff vs. previous snapshot: +15/-0/~33 (added/removed/changed)**
```diff
+ (added) Ascension
+ (added) Blitz
+ (added) CloseShave
+ (added) Crucifixion
+ (added) DeepSpiderDouble
+ (added) Edenstaff
+ (added) FireForge
+ (added) FlameRepulsionSpring
+ (added) ImperatorRunCrit
+ (added) LightningClones
+ (added) LightningStream
+ (added) PumpkinThrow
+ (added) RisingShadow
+ (added) SmoulderingHallow
+ (added) TwisterKicks
+ (changed) Smite
+ (changed) FirePalm
+ (changed) SwordCritical
+ (changed) BloodCross
+ (changed) TelegraphMinor
+ (changed) GreatswordCritical
+ (changed) GremorianLongSpear
+ (changed) BrutePunch
+ (changed) ShadowGun
+ (changed) WeaponUppercutTest
+ (changed) ShadowEruptionCast
+ (changed) WeaponFlourishTest
+ (changed) LightningAssault
+ (changed) TitusDrive
+ (changed) DeepSpiderBite
+ (changed) OwlDisperse
+ (changed) WeaponRunningAttackTest
+ (changed) DaggerCritical
+ (changed) IceForgeCast
+ (changed) SpearCritical
+ (changed) WhalingCrit
+ (changed) GreataxeCritical
+ (changed) RapidPunches
+ (changed) WindGun
+ (changed) WeaponTest
+ (changed) SilentheartHeavyMayhem
+ (changed) DeepSpiderSwing
+ (changed) DukeStomp
+ (changed) LionfishBeam
+ (changed) GrandJavelin
+ (changed) IceDaggers
+ (changed) RifleSpearCrit
+ (changed) SilentheartHeavyRelentless
```

**Timing diff vs. previous snapshot: +19/-5/~202 (animation: +16/-2/~194, part: +3/-3/~6, sound: +0/-0/~1, effect: +0/-0/~1)**
```diff
+ (changed) Animation : DrakemawCrit (by Juanito)
+ (changed) Animation : TollM1_1 (by Juanito)
+ (changed) Animation : ToonsM1_1 (by Blastbrean)
+ (changed) Animation : ToonsM1_2 (by Blastbrean)
+ (changed) Animation : ToonsM1_3 (by Blastbrean)
+ (added) Animation : TollM1_3 (by Juanito)
+ (changed) Animation : TollM1_2 (by Juanito)
+ (changed) Animation : SpectralM1_3 (by Blastbrean)
+ (changed) Animation : SpectralM1_2 (by Blastbrean)
+ (changed) Animation : SpectralM1_1 (by Blastbrean)
+ (changed) Animation : WealnWoeM1_2 (by Juanito)
+ (changed) Animation : WealnWoeM1_1 (by Juanito)
+ (changed) Animation : UmbriteSwing2 (by Juanito)
+ (changed) Animation : UmbriteSwing1 (by Juanito)
+ (changed) Animation : UmbriteSwing3 (by Juanito)
+ (changed) Animation : WealnWoeM1_3 (by Juanito)
+ (changed) Animation : Scythe_1 (by Juanito)
+ (changed) Animation : Scythe_2 (by Juanito)
+ (changed) Animation : RailbladeM1_1 (by Juanito)
+ (changed) Animation : RailbladeM1_3 (by Juanito)
+ (changed) Animation : RailbladeM1_2 (by Juanito)
+ (changed) Animation : PyreKeeperM1_3 (by Juanito)
+ (changed) Animation : PyreKeeperM1_1 (by Juanito)
+ (changed) Animation : PyreKeeperM1_2 (by Juanito)
+ (changed) Animation : PurpleCloud2 (by Juanito)
+ (changed) Animation : PurpleCloud3 (by Juanito)
+ (changed) Animation : PurpleCloud1 (by Juanito)
+ (changed) Animation : MaliceM1_1 (by Juanito)
+ (changed) Animation : MaliceM1_3 (by Juanito)
+ (changed) Animation : MaliceM1_2 (by Juanito)
+ (changed) Animation : MaliceM1_4 (by Juanito)
+ (changed) Animation : CanorFangCrit (by Juanito)
+ (added) Animation : IronRunningCrit (by Juanito)
+ (changed) Animation : NemitsSickleCrit (by Juanito)
+ (changed) Animation : 1_GenericFangCoil2 (by Juanito)
+ (changed) Animation : 1_GenericFangCoil3 (by Juanito)
+ (changed) Animation : 1_GenericFangCoil1 (by Juanito)
+ (added) Animation : FangRunningCrit (by Juanito)
+ (changed) Animation : 1_GenericLegionKata1 (by Juanito)
+ (changed) Animation : 1_GenericLegionKata3 (by Juanito)
+ (changed) Animation : 1_GenericLegionKata2 (by Juanito)
+ (changed) Animation : 1_GenericLegionKataFlourish (by Juanito)
+ (changed) Animation : 1_GenericGaleKata1 (by Blastbrean)
+ (changed) Animation : 1_GenericGaleKata2 (by Blastbrean)
+ (changed) Animation : TempestBlitz (by Juanito)
+ (changed) Animation : 1_GenericDaggerUppercut (by Juanito)
+ (changed) Animation : 1_GenericDagger1 (by Juanito)
+ (changed) Animation : 1_GenericDagger2 (by Juanito)
+ (changed) Animation : 1_GenericDagger3 (by Juanito)
+ (changed) Animation : TwisterKicks (by Juanito)
+ (changed) Animation : KrulianKnifeCrit (by Juanito)
+ (changed) Animation : 1SwordSwing2 (by Juanito)
+ (changed) Animation : 1_GenericHeavyAerial (by Juanito)
+ (changed) Animation : SwordCritical (by Juanito)
+ (changed) Animation : 2_GenericSpear1 (by Juanito)
+ (changed) Animation : 2_GenericSpear2 (by Juanito)
+ (changed) Animation : AuthorityOppressive (by Juanito)
+ (changed) Animation : 1_GenericGreatAxe3 (by Juanito)
+ (changed) Animation : 1_GenericGreatAxe2 (by Juanito)
+ (changed) Animation : 1_GenericGreatAxe1 (by Juanito)
+ (changed) Animation : 1_GenericNavae2 (by Juanito)
+ (changed) Animation : 1_GenericNavae1 (by Juanito)
+ (changed) Animation : 1_GenericNavae3 (by Juanito)
+ (changed) Animation : AuthortyPunchFloruish (by Juanito)
+ (changed) Animation : GreatswordCritical (by Juanito)
+ (changed) Animation : LightningChoke (by Juanito)
+ (changed) Animation : 1_GenericFlourish (by Juanito)
+ (changed) Animation : 2_GenericGreatsword2 (by Juanito)
+ (changed) Animation : 2_GenericGreatsword1 (by Juanito)
+ (added) Animation : IceSmashFollowup (by Juanito)
+ (changed) Animation : IceSmash (by Juanito)
+ (changed) Animation : CrystalImpaleWindup (by Juanito)
+ (changed) Animation : IceSaber2 (by Juanito)
+ (changed) Animation : IceSaber1 (by Juanito)
+ (changed) Animation : IceSaber3 (by Juanito)
+ (changed) Animation : 1_GenericSword1 (by Juanito)
+ (changed) Animation : 1_GenericSword2 (by Juanito)
+ (added) Animation : TacetDropKick (by Juanito)
+ (changed) Animation : 1_GenericKarita1 (by Blastbrean)
+ (changed) Animation : 1SwordSwing1 (by Juanito)
+ (changed) Animation : SpearCritical (by Juanito)
+ (changed) Animation : ArdourSlicer (by Juanito)
+ (changed) Animation : ShatteredKatanaCrit (by Juanito)
+ (changed) Animation : ExhaustionStrike (by Blastbrean)
+ (changed) Animation : 2_GenericBow3 (by Juanito)
+ (changed) Animation : 2_GenericBow1 (by Juanito)
+ (changed) Animation : 2_GenericBow2 (by Juanito)
+ (changed) Animation : 2_GenericBowFlourish (by Juanito)
+ (changed) Animation : PumpkinThrow (by Juanito)
+ (changed) Animation : 1_GenericGaleKata3 (by Juanito)
+ (changed) nimation : 1_GenericPistolShot2
+ (changed) Animation : 1_GenericGaleKata4 (by Juanito)
+ (changed) Animation : EclipseKick (by Juanito)
+ (changed) Animation : 1_GenericPistolShot1 (by Juanito)
+ (changed) Animation : FlameRepulsion (by Juanito)
+ (changed) Animation : 1_GenericKaritaFlourish (by Juanito)
+ (changed) Animation : 1_GenericGreatsword2 (by Juanito)
+ (changed) Animation : ContractorPull (by Blastbrean)
+ (changed) Animation : 1_GenericMusket3 (by Blastbrean)
+ (changed) Animation : WindCarve (by Blastbrean)
+ (changed) Animation : FirstLight1 (by Blastbrean)
+ (changed) Animation : 1_GenericMusket2 (by Blastbrean)
+ (changed) Animation : BloodFoulerM1_2 (by Blastbrean)
+ (changed) Animation : FirstLight2 (by Blastbrean)
+ (changed) Animation : 1_GenericKarita3 (by Blastbrean)
+ (changed) Animation : 2_GenericTwinblade1 (by Blastbrean)
+ (changed) Animation : 1_GenericGreatsword1 (by Juanito)
+ (changed) Animation : ShoulderBashGo (by Blastbrean)
+ (changed) Animation : 1_GenericTwinblade1 (by Blastbrean)
+ (changed) Animation : 1_GenericPistol2 (by Juanito)
+ (changed) Animation : 2_GenericTwinblade2 (by Blastbrean)
+ (changed) Animation : 1_GenericKarita2 (by Blastbrean)
+ (changed) Animation : 1_GenericMusket1 (by Blastbrean)
+ (changed) Animation : ShoulderBashWindup (by Blastbrean)
+ (changed) Animation : RisingFlameWindup (by Juanito)
+ (changed) Animation : JetstrikerKick (by Juanito)
+ (changed) Animation : 1_GenericSpearUppercut (by Blastbrean)
+ (changed) Animation : ShadowEruptionCast (by Juanito)
+ (changed) Animation : 2_GenericPistol1 (by Juanito)
+ (changed) Animation : 1_GenericPistolShot3 (by Juanito)
+ (changed) Animation : 1_GenericGreatcannon1 (by Juanito)
+ (changed) Animation : BlooudFoulerM1_3 (by Blastbrean)
+ (changed) Animation : 2_GenericPistol2 (by Juanito)
+ (changed) Animation : PromDraw (by Blastbrean)
+ (changed) Animation : 1CurvedSwing4? (by Blastbrean)
+ (changed) Animation : 1_GenericPistol1 (by Juanito)
+ (changed) Animation : MastersFlourish (by Blastbrean)
+ (changed) Animation : 1_GenericSpear1 (by Juanito)
+ (changed) Animation : IceForgeCast (by Blastbrean)
+ (changed) Animation : 1CurvedSwing1 (by Blastbrean)
+ (changed) Animation : 1_GenericPistolUppercut (by Juanito)
+ (changed) Animation : 1_GenericRapier1 (by Juanito)
+ (changed) Animation : 1_GenericGreatcannon2 (by Juanito)
+ (changed) Animation : BloodFoulerM1_1 (by Juanito)
+ (changed) Animation : IceLance (by Blastbrean)
+ (changed) Animation : 1_GenericRapier2 (by Juanito)
+ (changed) Animation : 1_GenericSpear2 (by Juanito)
+ (changed) Animation : BloodCurdle (by Blastbrean)
+ (changed) Animation : RazorBlitz (by Blastbrean)
+ (changed) Animation : FrostGrabWindup (by Blastbrean)
+ (changed) Animation : GaleLungeGo (by Juanito)
+ (changed) Animation : MirrorIllusion (by Blastbrean)
+ (changed) Animation : FlamingScourgeReversal (by Blastbrean)
+ (changed) Animation : FlameAssault (by Blastbrean)
+ (changed) Animation : FireBlade (by Juanito)
+ (changed) Animation : 1_GenericSwordUppercut (by Juanito)
+ (changed) Animation : 1_GenericNavaeFlourish (by Juanito)
+ (changed) Animation : 1_GenericHeavyUppercut (by Juanito)
+ (changed) Animation : 1_GenericGreathammerUppercut (by Juanito)
+ (changed) Animation : MayhemSilentheart (by Blastbrean)
+ (changed) Animation : DukeStomp (by Juanito)
+ (changed) Animation : IceHeroCrit (by Juanito)
+ (added) Animation : 1_GenericCannonRunning (by Juanito)
+ (added) Animation : LightningClones (by Juanito)
+ (changed) Animation : WealnWoeRunningCrit (by Juanito)
+ (changed) Animation : WealnWoeCrit (by Juanito)
+ (changed) Animation : SkullPiercerCrit (by Juanito)
+ (changed) Animation : DaggerCritical (by Juanito)
+ (added) Animation : ImperatorsRunningCrit (by Juanito)
+ (changed) Animation : PastryPasterCrit (by Juanito)
+ (changed) Animation : PrecisionCuts (by Juanito)
+ (changed) Animation : CloseShave (by Juanito)
+ (changed) Animation : BruteHeavyPunch (by Juanito)
+ (changed) Animation : CrabboRexBeam (by Juanito)
+ (changed) Animation : LionfishBeam (by Juanito)
+ (changed) Animation : LionfishTripleBite (by Juanito)
+ (changed) Animation : FlameGrab (by Juanito)
- (removed) Animation : LightningStream (by Juanito)
+ (added) Animation : LightningStreamWindup (by Juanito)
+ (changed) Animation : LightningKick (by Juanito)
+ (changed) Animation : TitusLariat (by Juanito)
+ (changed) Animation : JetstrikerFakeStrike (by Juanito)
+ (changed) Animation : ShadowAssault (by Juanito)
+ (changed) Animation : FlashdrawStrike (by Juanito)
+ (changed) Animation : FlashfireSweep (by Juanito)
+ (changed) Animation : AscensionWindup (by Juanito)
+ (changed) Animation : SinisterHalo (by Juanito)
+ (changed) Animation : CelestialAssault (by Juanito)
+ (changed) Animation : FlameLeap (by Juanito)
+ (changed) Animation : FlameLeapReversal (by Juanito)
+ (changed) Animation : MetalDropKick (by Juanito)
+ (changed) Animation : GremorianLongSpearCrit (by Juanito)
+ (changed) Animation : EdenstaffCrit (by Juanito)
+ (changed) Animation : BloodCross (by Juanito)
+ (changed) Animation : RadiantDawn (by Juanito)
+ (changed) Animation : FireForgeWindup (by Juanito)
+ (added) Animation : FlameRepulsionSpring (by Juanito)
+ (changed) Animation : GaleLungeWindup (by Juanito)
+ (added) Animation : ParalyticDustAOE (by Juanito)
+ (changed) Animation : ParalyticDust (by Juanito)
+ (added) Animation : PortalsKick (by Juanito)
- (removed) Animation : ShardBow (by Juanito)
+ (added) Animation : ShardBowWindup (by Juanito)
+ (changed) Animation : AstralWind (by Juanito)
+ (changed) Animation : WealnWoeFloruish (by Juanito)
+ (changed) Animation : IceBeam (by Juanito)
+ (changed) Animation : LethalInjection (by Juanito)
+ (changed) Animation : RisingFrost (by Juanito)
+ (changed) Animation : GreataxeCritical (by Juanito)
+ (changed) Animation : ClubCritical (by Juanito)
+ (added) Animation : RisingShadow (by Juanito)
+ (changed) Animation : Restrain (by Juanito)
+ (changed) Animation : Restrain_2 (by Juanito)
+ (added) Animation : EclipseKick2 (by Juanito)
+ (changed) Animation : ChampionsWhirlthrow (by Juanito)
+ (changed) Animation : StoneKnightSwing1 (by Juanito)
+ (changed) Animation : StoneKnightSwing2 (by Juanito)
+ (changed) Animation : StoneKnightKick (by Juanito)
+ (changed) Animation : StoneKnightPunch (by Juanito)
+ (added) Animation : SmoulderingCrit (by Juanito)
+ (changed) Animation : DeepSpiderDoubleStab (by Juanito)
+ (changed) Animation : 1CurvedSwing2 (by Blastbrean)
+ (changed) Part : PaleBriarCrit (by Juanito)
+ (changed) Part : ShadowMetero (by Blastbrean)
+ (added) Part : IceBird (by Blastbrean)
+ (added) Part : SmiteBall2 (by Blastbrean)
- (removed) Part : LightningStreamPart (by Juanito)
- (removed) Part : RisingShadow (by Juanito)
+ (added) Part : SinisterHalo (by Juanito)
+ (changed) Part : TrialOrbs (by Juanito)
+ (changed) Part : SmiteBall (by Juanito)
- (removed) Part : PaybackBeam (by Juanito)
+ (changed) Part : Shard (by Juanito)
+ (changed) Part : WindSlashProjectile (by Juanito)
+ (changed) Sound : Iceberg (by Juanito)
+ (changed) Effect : OwlDisperse (by Juanito)
```

**New features?**
```diff
+ (added) Auto Joy Farm (only is shown when in a Dungeon)
+ (added) Player Armor ESP
```

*Your commit ID should == "19b9ce" when the update is fully pushed to you.*