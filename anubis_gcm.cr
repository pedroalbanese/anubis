require "random/secure"

module Anubis
  # S-boxes and transformation tables
  T0 = [
    0xba69d2bb_u32, 0x54a84de5_u32, 0x2f5ebce2_u32, 0x74e8cd25_u32,
    0x53a651f7_u32, 0xd3bb6bd0_u32, 0xd2b96fd6_u32, 0x4d9a29b3_u32,
    0x50a05dfd_u32, 0xac458acf_u32, 0x8d070e09_u32, 0xbf63c6a5_u32,
    0x70e0dd3d_u32, 0x52a455f1_u32, 0x9a29527b_u32, 0x4c982db5_u32,
    0xeac98f46_u32, 0xd5b773c4_u32, 0x97336655_u32, 0xd1bf63dc_u32,
    0x3366ccaa_u32, 0x51a259fb_u32, 0x5bb671c7_u32, 0xa651a2f3_u32,
    0xdea15ffe_u32, 0x48903dad_u32, 0xa84d9ad7_u32, 0x992f5e71_u32,
    0xdbab4be0_u32, 0x3264c8ac_u32, 0xb773e695_u32, 0xfce5d732_u32,
    0xe3dbab70_u32, 0x9e214263_u32, 0x913f7e41_u32, 0x9b2b567d_u32,
    0xe2d9af76_u32, 0xbb6bd6bd_u32, 0x4182199b_u32, 0x6edca579_u32,
    0xa557aef9_u32, 0xcb8b0b80_u32, 0x6bd6b167_u32, 0x95376e59_u32,
    0xa15fbee1_u32, 0xf3fbeb10_u32, 0xb17ffe81_u32, 0x0204080c_u32,
    0xcc851792_u32, 0xc49537a2_u32, 0x1d3a744e_u32, 0x14285078_u32,
    0xc39b2bb0_u32, 0x63c69157_u32, 0xdaa94fe6_u32, 0x5dba69d3_u32,
    0x5fbe61df_u32, 0xdca557f2_u32, 0x7dfae913_u32, 0xcd871394_u32,
    0x7ffee11f_u32, 0x5ab475c1_u32, 0x6cd8ad75_u32, 0x5cb86dd5_u32,
    0xf7f3fb08_u32, 0x264c98d4_u32, 0xffe3db38_u32, 0xedc79354_u32,
    0xe8cd874a_u32, 0x9d274e69_u32, 0x6fdea17f_u32, 0x8e010203_u32,
    0x19326456_u32, 0xa05dbae7_u32, 0xf0fde71a_u32, 0x890f1e11_u32,
    0x0f1e3c22_u32, 0x070e1c12_u32, 0xaf4386c5_u32, 0xfbebcb20_u32,
    0x08102030_u32, 0x152a547e_u32, 0x0d1a342e_u32, 0x04081018_u32,
    0x01020406_u32, 0x64c88d45_u32, 0xdfa35bf8_u32, 0x76ecc529_u32,
    0x79f2f90b_u32, 0xdda753f4_u32, 0x3d7af48e_u32, 0x162c5874_u32,
    0x3f7efc82_u32, 0x376edcb2_u32, 0x6ddaa973_u32, 0x3870e090_u32,
    0xb96fdeb1_u32, 0x73e6d137_u32, 0xe9cf834c_u32, 0x356ad4be_u32,
    0x55aa49e3_u32, 0x71e2d93b_u32, 0x7bf6f107_u32, 0x8c050a0f_u32,
    0x72e4d531_u32, 0x880d1a17_u32, 0xf6f1ff0e_u32, 0x2a54a8fc_u32,
    0x3e7cf884_u32, 0x5ebc65d9_u32, 0x274e9cd2_u32, 0x468c0589_u32,
    0x0c183028_u32, 0x65ca8943_u32, 0x68d0bd6d_u32, 0x61c2995b_u32,
    0x03060c0a_u32, 0xc19f23bc_u32, 0x57ae41ef_u32, 0xd6b17fce_u32,
    0xd9af43ec_u32, 0x58b07dcd_u32, 0xd8ad47ea_u32, 0x66cc8549_u32,
    0xd7b37bc8_u32, 0x3a74e89c_u32, 0xc88d078a_u32, 0x3c78f088_u32,
    0xfae9cf26_u32, 0x96316253_u32, 0xa753a6f5_u32, 0x982d5a77_u32,
    0xecc59752_u32, 0xb86ddab7_u32, 0xc7933ba8_u32, 0xae4182c3_u32,
    0x69d2b96b_u32, 0x4b9631a7_u32, 0xab4b96dd_u32, 0xa94f9ed1_u32,
    0x67ce814f_u32, 0x0a14283c_u32, 0x478e018f_u32, 0xf2f9ef16_u32,
    0xb577ee99_u32, 0x224488cc_u32, 0xe5d7b364_u32, 0xeec19f5e_u32,
    0xbe61c2a3_u32, 0x2b56acfa_u32, 0x811f3e21_u32, 0x1224486c_u32,
    0x831b362d_u32, 0x1b366c5a_u32, 0x0e1c3824_u32, 0x23468cca_u32,
    0xf5f7f304_u32, 0x458a0983_u32, 0x214284c6_u32, 0xce811f9e_u32,
    0x499239ab_u32, 0x2c58b0e8_u32, 0xf9efc32c_u32, 0xe6d1bf6e_u32,
    0xb671e293_u32, 0x2850a0f0_u32, 0x172e5c72_u32, 0x8219322b_u32,
    0x1a34685c_u32, 0x8b0b161d_u32, 0xfee1df3e_u32, 0x8a09121b_u32,
    0x09122436_u32, 0xc98f038c_u32, 0x87132635_u32, 0x4e9c25b9_u32,
    0xe1dfa37c_u32, 0x2e5cb8e4_u32, 0xe4d5b762_u32, 0xe0dda77a_u32,
    0xebcb8b40_u32, 0x903d7a47_u32, 0xa455aaff_u32, 0x1e3c7844_u32,
    0x85172e39_u32, 0x60c09d5d_u32, 0x00000000_u32, 0x254a94de_u32,
    0xf4f5f702_u32, 0xf1ffe31c_u32, 0x94356a5f_u32, 0x0b162c3a_u32,
    0xe7d3bb68_u32, 0x75eac923_u32, 0xefc39b58_u32, 0x3468d0b8_u32,
    0x3162c4a6_u32, 0xd4b577c2_u32, 0xd0bd67da_u32, 0x86112233_u32,
    0x7efce519_u32, 0xad478ec9_u32, 0xfde7d334_u32, 0x2952a4f6_u32,
    0x3060c0a0_u32, 0x3b76ec9a_u32, 0x9f234665_u32, 0xf8edc72a_u32,
    0xc6913fae_u32, 0x13264c6a_u32, 0x060c1814_u32, 0x050a141e_u32,
    0xc59733a4_u32, 0x11224466_u32, 0x77eec12f_u32, 0x7cf8ed15_u32,
    0x7af4f501_u32, 0x78f0fd0d_u32, 0x366cd8b4_u32, 0x1c387048_u32,
    0x3972e496_u32, 0x59b279cb_u32, 0x18306050_u32, 0x56ac45e9_u32,
    0xb37bf68d_u32, 0xb07dfa87_u32, 0x244890d8_u32, 0x204080c0_u32,
    0xb279f28b_u32, 0x9239724b_u32, 0xa35bb6ed_u32, 0xc09d27ba_u32,
    0x44880d85_u32, 0x62c49551_u32, 0x10204060_u32, 0xb475ea9f_u32,
    0x84152a3f_u32, 0x43861197_u32, 0x933b764d_u32, 0xc2992fb6_u32,
    0x4a9435a1_u32, 0xbd67cea9_u32, 0x8f030605_u32, 0x2d5ab4ee_u32,
    0xbc65caaf_u32, 0x9c254a6f_u32, 0x6ad4b561_u32, 0x40801d9d_u32,
    0xcf831b98_u32, 0xa259b2eb_u32, 0x801d3a27_u32, 0x4f9e21bf_u32,
    0x1f3e7c42_u32, 0xca890f86_u32, 0xaa4992db_u32, 0x42841591_u32
  ]

  T1 = [
    0x69babbd2_u32, 0xa854e54d_u32, 0x5e2fe2bc_u32, 0xe87425cd_u32,
    0xa653f751_u32, 0xbbd3d06b_u32, 0xb9d2d66f_u32, 0x9a4db329_u32,
    0xa050fd5d_u32, 0x45accf8a_u32, 0x078d090e_u32, 0x63bfa5c6_u32,
    0xe0703ddd_u32, 0xa452f155_u32, 0x299a7b52_u32, 0x984cb52d_u32,
    0xc9ea468f_u32, 0xb7d5c473_u32, 0x33975566_u32, 0xbfd1dc63_u32,
    0x6633aacc_u32, 0xa251fb59_u32, 0xb65bc771_u32, 0x51a6f3a2_u32,
    0xa1defe5f_u32, 0x9048ad3d_u32, 0x4da8d79a_u32, 0x2f99715e_u32,
    0xabdbe04b_u32, 0x6432acc8_u32, 0x73b795e6_u32, 0xe5fc32d7_u32,
    0xdbe370ab_u32, 0x219e6342_u32, 0x3f91417e_u32, 0x2b9b7d56_u32,
    0xd9e276af_u32, 0x6bbbbdd6_u32, 0x82419b19_u32, 0xdc6e79a5_u32,
    0x57a5f9ae_u32, 0x8bcb800b_u32, 0xd66b67b1_u32, 0x3795596e_u32,
    0x5fa1e1be_u32, 0xfbf310eb_u32, 0x7fb181fe_u32, 0x04020c08_u32,
    0x85cc9217_u32, 0x95c4a237_u32, 0x3a1d4e74_u32, 0x28147850_u32,
    0x9bc3b02b_u32, 0xc6635791_u32, 0xa9dae64f_u32, 0xba5dd369_u32,
    0xbe5fdf61_u32, 0xa5dcf257_u32, 0xfa7d13e9_u32, 0x87cd9413_u32,
    0xfe7f1fe1_u32, 0xb45ac175_u32, 0xd86c75ad_u32, 0xb85cd56d_u32,
    0xf3f708fb_u32, 0x4c26d498_u32, 0xe3ff38db_u32, 0xc7ed5493_u32,
    0xcde84a87_u32, 0x279d694e_u32, 0xde6f7fa1_u32, 0x018e0302_u32,
    0x32195664_u32, 0x5da0e7ba_u32, 0xfdf01ae7_u32, 0x0f89111e_u32,
    0x1e0f223c_u32, 0x0e07121c_u32, 0x43afc586_u32, 0xebfb20cb_u32,
    0x10083020_u32, 0x2a157e54_u32, 0x1a0d2e34_u32, 0x08041810_u32,
    0x02010604_u32, 0xc864458d_u32, 0xa3dff85b_u32, 0xec7629c5_u32,
    0xf2790bf9_u32, 0xa7ddf453_u32, 0x7a3d8ef4_u32, 0x2c167458_u32,
    0x7e3f82fc_u32, 0x6e37b2dc_u32, 0xda6d73a9_u32, 0x703890e0_u32,
    0x6fb9b1de_u32, 0xe67337d1_u32, 0xcfe94c83_u32, 0x6a35bed4_u32,
    0xaa55e349_u32, 0xe2713bd9_u32, 0xf67b07f1_u32, 0x058c0f0a_u32,
    0xe47231d5_u32, 0x0d88171a_u32, 0xf1f60eff_u32, 0x542afca8_u32,
    0x7c3e84f8_u32, 0xbc5ed965_u32, 0x4e27d29c_u32, 0x8c468905_u32,
    0x180c2830_u32, 0xca654389_u32, 0xd0686dbd_u32, 0xc2615b99_u32,
    0x06030a0c_u32, 0x9fc1bc23_u32, 0xae57ef41_u32, 0xb1d6ce7f_u32,
    0xafd9ec43_u32, 0xb058cd7d_u32, 0xadd8ea47_u32, 0xcc664985_u32,
    0xb3d7c87b_u32, 0x743a9ce8_u32, 0x8dc88a07_u32, 0x783c88f0_u32,
    0xe9fa26cf_u32, 0x31965362_u32, 0x53a7f5a6_u32, 0x2d98775a_u32,
    0xc5ec5297_u32, 0x6db8b7da_u32, 0x93c7a83b_u32, 0x41aec382_u32,
    0xd2696bb9_u32, 0x964ba731_u32, 0x4babdd96_u32, 0x4fa9d19e_u32,
    0xce674f81_u32, 0x140a3c28_u32, 0x8e478f01_u32, 0xf9f216ef_u32,
    0x77b599ee_u32, 0x4422cc88_u32, 0xd7e564b3_u32, 0xc1ee5e9f_u32,
    0x61bea3c2_u32, 0x562bfaac_u32, 0x1f81213e_u32, 0x24126c48_u32,
    0x1b832d36_u32, 0x361b5a6c_u32, 0x1c0e2438_u32, 0x4623ca8c_u32,
    0xf7f504f3_u32, 0x8a458309_u32, 0x4221c684_u32, 0x81ce9e1f_u32,
    0x9249ab39_u32, 0x582ce8b0_u32, 0xeff92cc3_u32, 0xd1e66ebf_u32,
    0x71b693e2_u32, 0x5028f0a0_u32, 0x2e17725c_u32, 0x19822b32_u32,
    0x341a5c68_u32, 0x0b8b1d16_u32, 0xe1fe3edf_u32, 0x098a1b12_u32,
    0x12093624_u32, 0x8fc98c03_u32, 0x13873526_u32, 0x9c4eb925_u32,
    0xdfe17ca3_u32, 0x5c2ee4b8_u32, 0xd5e462b7_u32, 0xdde07aa7_u32,
    0xcbeb408b_u32, 0x3d90477a_u32, 0x55a4ffaa_u32, 0x3c1e4478_u32,
    0x1785392e_u32, 0xc0605d9d_u32, 0x00000000_u32, 0x4a25de94_u32,
    0xf5f402f7_u32, 0xfff11ce3_u32, 0x35945f6a_u32, 0x160b3a2c_u32,
    0xd3e768bb_u32, 0xea7523c9_u32, 0xc3ef589b_u32, 0x6834b8d0_u32,
    0x6231a6c4_u32, 0xb5d4c277_u32, 0xbdd0da67_u32, 0x11863322_u32,
    0xfc7e19e5_u32, 0x47adc98e_u32, 0xe7fd34d3_u32, 0x5229f6a4_u32,
    0x6030a0c0_u32, 0x763b9aec_u32, 0x239f6546_u32, 0xedf82ac7_u32,
    0x91c6ae3f_u32, 0x26136a4c_u32, 0x0c061418_u32, 0x0a051e14_u32,
    0x97c5a433_u32, 0x22116644_u32, 0xee772fc1_u32, 0xf87c15ed_u32,
    0xf47a01f5_u32, 0xf0780dfd_u32, 0x6c36b4d8_u32, 0x381c4870_u32,
    0x723996e4_u32, 0xb259cb79_u32, 0x30185060_u32, 0xac56e945_u32,
    0x7bb38df6_u32, 0x7db087fa_u32, 0x4824d890_u32, 0x4020c080_u32,
    0x79b28bf2_u32, 0x39924b72_u32, 0x5ba3edb6_u32, 0x9dc0ba27_u32,
    0x8844850d_u32, 0xc4625195_u32, 0x20106040_u32, 0x75b49fea_u32,
    0x15843f2a_u32, 0x86439711_u32, 0x3b934d76_u32, 0x99c2b62f_u32,
    0x944aa135_u32, 0x67bda9ce_u32, 0x038f0506_u32, 0x5a2deeb4_u32,
    0x65bcafca_u32, 0x259c6f4a_u32, 0xd46a61b5_u32, 0x80409d1d_u32,
    0x83cf981b_u32, 0x59a2ebb2_u32, 0x1d80273a_u32, 0x9e4fbf21_u32,
    0x3e1f427c_u32, 0x89ca860f_u32, 0x49aadb92_u32, 0x84429115_u32
  ]

  T2 = [
    0xd2bbba69_u32, 0x4de554a8_u32, 0xbce22f5e_u32, 0xcd2574e8_u32,
    0x51f753a6_u32, 0x6bd0d3bb_u32, 0x6fd6d2b9_u32, 0x29b34d9a_u32,
    0x5dfd50a0_u32, 0x8acfac45_u32, 0x0e098d07_u32, 0xc6a5bf63_u32,
    0xdd3d70e0_u32, 0x55f152a4_u32, 0x527b9a29_u32, 0x2db54c98_u32,
    0x8f46eac9_u32, 0x73c4d5b7_u32, 0x66559733_u32, 0x63dcd1bf_u32,
    0xccaa3366_u32, 0x59fb51a2_u32, 0x71c75bb6_u32, 0xa2f3a651_u32,
    0x5ffedea1_u32, 0x3dad4890_u32, 0x9ad7a84d_u32, 0x5e71992f_u32,
    0x4be0dbab_u32, 0xc8ac3264_u32, 0xe695b773_u32, 0xd732fce5_u32,
    0xab70e3db_u32, 0x42639e21_u32, 0x7e41913f_u32, 0x567d9b2b_u32,
    0xaf76e2d9_u32, 0xd6bdbb6b_u32, 0x199b4182_u32, 0xa5796edc_u32,
    0xaef9a557_u32, 0x0b80cb8b_u32, 0xb1676bd6_u32, 0x6e599537_u32,
    0xbee1a15f_u32, 0xeb10f3fb_u32, 0xfe81b17f_u32, 0x080c0204_u32,
    0x1792cc85_u32, 0x37a2c495_u32, 0x744e1d3a_u32, 0x50781428_u32,
    0x2bb0c39b_u32, 0x915763c6_u32, 0x4fe6daa9_u32, 0x69d35dba_u32,
    0x61df5fbe_u32, 0x57f2dca5_u32, 0xe9137dfa_u32, 0x1394cd87_u32,
    0xe11f7ffe_u32, 0x75c15ab4_u32, 0xad756cd8_u32, 0x6dd55cb8_u32,
    0xfb08f7f3_u32, 0x98d4264c_u32, 0xdb38ffe3_u32, 0x9354edc7_u32,
    0x874ae8cd_u32, 0x4e699d27_u32, 0xa17f6fde_u32, 0x02038e01_u32,
    0x64561932_u32, 0xbae7a05d_u32, 0xe71af0fd_u32, 0x1e11890f_u32,
    0x3c220f1e_u32, 0x1c12070e_u32, 0x86c5af43_u32, 0xcb20fbeb_u32,
    0x20300810_u32, 0x547e152a_u32, 0x342e0d1a_u32, 0x10180408_u32,
    0x04060102_u32, 0x8d4564c8_u32, 0x5bf8dfa3_u32, 0xc52976ec_u32,
    0xf90b79f2_u32, 0x53f4dda7_u32, 0xf48e3d7a_u32, 0x5874162c_u32,
    0xfc823f7e_u32, 0xdcb2376e_u32, 0xa9736dda_u32, 0xe0903870_u32,
    0xdeb1b96f_u32, 0xd13773e6_u32, 0x834ce9cf_u32, 0xd4be356a_u32,
    0x49e355aa_u32, 0xd93b71e2_u32, 0xf1077bf6_u32, 0x0a0f8c05_u32,
    0xd53172e4_u32, 0x1a17880d_u32, 0xff0ef6f1_u32, 0xa8fc2a54_u32,
    0xf8843e7c_u32, 0x65d95ebc_u32, 0x9cd2274e_u32, 0x0589468c_u32,
    0x30280c18_u32, 0x894365ca_u32, 0xbd6d68d0_u32, 0x995b61c2_u32,
    0x0c0a0306_u32, 0x23bcc19f_u32, 0x41ef57ae_u32, 0x7fced6b1_u32,
    0x43ecd9af_u32, 0x7dcd58b0_u32, 0x47ead8ad_u32, 0x854966cc_u32,
    0x7bc8d7b3_u32, 0xe89c3a74_u32, 0x078ac88d_u32, 0xf0883c78_u32,
    0xcf26fae9_u32, 0x62539631_u32, 0xa6f5a753_u32, 0x5a77982d_u32,
    0x9752ecc5_u32, 0xdab7b86d_u32, 0x3ba8c793_u32, 0x82c3ae41_u32,
    0xb96b69d2_u32, 0x31a74b96_u32, 0x96ddab4b_u32, 0x9ed1a94f_u32,
    0x814f67ce_u32, 0x283c0a14_u32, 0x018f478e_u32, 0xef16f2f9_u32,
    0xee99b577_u32, 0x88cc2244_u32, 0xb364e5d7_u32, 0x9f5eeec1_u32,
    0xc2a3be61_u32, 0xacfa2b56_u32, 0x3e21811f_u32, 0x486c1224_u32,
    0x362d831b_u32, 0x6c5a1b36_u32, 0x38240e1c_u32, 0x8cca2346_u32,
    0xf304f5f7_u32, 0x0983458a_u32, 0x84c62142_u32, 0x1f9ece81_u32,
    0x39ab4992_u32, 0xb0e82c58_u32, 0xc32cf9ef_u32, 0xbf6ee6d1_u32,
    0xe293b671_u32, 0xa0f02850_u32, 0x5c72172e_u32, 0x322b8219_u32,
    0x685c1a34_u32, 0x161d8b0b_u32, 0xdf3efee1_u32, 0x121b8a09_u32,
    0x24360912_u32, 0x038cc98f_u32, 0x26358713_u32, 0x25b94e9c_u32,
    0xa37ce1df_u32, 0xb8e42e5c_u32, 0xb762e4d5_u32, 0xa77ae0dd_u32,
    0x8b40ebcb_u32, 0x7a47903d_u32, 0xaaffa455_u32, 0x78441e3c_u32,
    0x2e398517_u32, 0x9d5d60c0_u32, 0x00000000_u32, 0x94de254a_u32,
    0xf702f4f5_u32, 0xe31cf1ff_u32, 0x6a5f9435_u32, 0x2c3a0b16_u32,
    0xbb68e7d3_u32, 0xc92375ea_u32, 0x9b58efc3_u32, 0xd0b83468_u32,
    0xc4a63162_u32, 0x77c2d4b5_u32, 0x67dad0bd_u32, 0x22338611_u32,
    0xe5197efc_u32, 0x8ec9ad47_u32, 0xd334fde7_u32, 0xa4f62952_u32,
    0xc0a03060_u32, 0xec9a3b76_u32, 0x46659f23_u32, 0xc72af8ed_u32,
    0x3faec691_u32, 0x4c6a1326_u32, 0x1814060c_u32, 0x141e050a_u32,
    0x33a4c597_u32, 0x44661122_u32, 0xc12f77ee_u32, 0xed157cf8_u32,
    0xf5017af4_u32, 0xfd0d78f0_u32, 0xd8b4366c_u32, 0x70481c38_u32,
    0xe4963972_u32, 0x79cb59b2_u32, 0x60501830_u32, 0x45e956ac_u32,
    0xf68db37b_u32, 0xfa87b07d_u32, 0x90d82448_u32, 0x80c02040_u32,
    0xf28bb279_u32, 0x724b9239_u32, 0xb6eda35b_u32, 0x27bac09d_u32,
    0x0d854488_u32, 0x955162c4_u32, 0x40601020_u32, 0xea9fb475_u32,
    0x2a3f8415_u32, 0x11974386_u32, 0x764d933b_u32, 0x2fb6c299_u32,
    0x35a14a94_u32, 0xcea9bd67_u32, 0x06058f03_u32, 0xb4ee2d5a_u32,
    0xcaafbc65_u32, 0x4a6f9c25_u32, 0xb5616ad4_u32, 0x1d9d4080_u32,
    0x1b98cf83_u32, 0xb2eba259_u32, 0x3a27801d_u32, 0x21bf4f9e_u32,
    0x7c421f3e_u32, 0x0f86ca89_u32, 0x92dbaa49_u32, 0x15914284_u32
  ]

  T3 = [
    0xbbd269ba_u32, 0xe54da854_u32, 0xe2bc5e2f_u32, 0x25cde874_u32,
    0xf751a653_u32, 0xd06bbbd3_u32, 0xd66fb9d2_u32, 0xb3299a4d_u32,
    0xfd5da050_u32, 0xcf8a45ac_u32, 0x090e078d_u32, 0xa5c663bf_u32,
    0x3ddde070_u32, 0xf155a452_u32, 0x7b52299a_u32, 0xb52d984c_u32,
    0x468fc9ea_u32, 0xc473b7d5_u32, 0x55663397_u32, 0xdc63bfd1_u32,
    0xaacc6633_u32, 0xfb59a251_u32, 0xc771b65b_u32, 0xf3a251a6_u32,
    0xfe5fa1de_u32, 0xad3d9048_u32, 0xd79a4da8_u32, 0x715e2f99_u32,
    0xe04babdb_u32, 0xacc86432_u32, 0x95e673b7_u32, 0x32d7e5fc_u32,
    0x70abdbe3_u32, 0x6342219e_u32, 0x417e3f91_u32, 0x7d562b9b_u32,
    0x76afd9e2_u32, 0xbdd66bbb_u32, 0x9b198241_u32, 0x79a5dc6e_u32,
    0xf9ae57a5_u32, 0x800b8bcb_u32, 0x67b1d66b_u32, 0x596e3795_u32,
    0xe1be5fa1_u32, 0x10ebfbf3_u32, 0x81fe7fb1_u32, 0x0c080402_u32,
    0x921785cc_u32, 0xa23795c4_u32, 0x4e743a1d_u32, 0x78502814_u32,
    0xb02b9bc3_u32, 0x5791c663_u32, 0xe64fa9da_u32, 0xd369ba5d_u32,
    0xdf61be5f_u32, 0xf257a5dc_u32, 0x13e9fa7d_u32, 0x941387cd_u32,
    0x1fe1fe7f_u32, 0xc175b45a_u32, 0x75add86c_u32, 0xd56db85c_u32,
    0x08fbf3f7_u32, 0xd4984c26_u32, 0x38dbe3ff_u32, 0x5493c7ed_u32,
    0x4a87cde8_u32, 0x694e279d_u32, 0x7fa1de6f_u32, 0x0302018e_u32,
    0x56643219_u32, 0xe7ba5da0_u32, 0x1ae7fdf0_u32, 0x111e0f89_u32,
    0x223c1e0f_u32, 0x121c0e07_u32, 0xc58643af_u32, 0x20cbebfb_u32,
    0x30201008_u32, 0x7e542a15_u32, 0x2e341a0d_u32, 0x18100804_u32,
    0x06040201_u32, 0x458dc864_u32, 0xf85ba3df_u32, 0x29c5ec76_u32,
    0x0bf9f279_u32, 0xf453a7dd_u32, 0x8ef47a3d_u32, 0x74582c16_u32,
    0x82fc7e3f_u32, 0xb2dc6e37_u32, 0x73a9da6d_u32, 0x90e07038_u32,
    0xb1de6fb9_u32, 0x37d1e673_u32, 0x4c83cfe9_u32, 0xbed46a35_u32,
    0xe349aa55_u32, 0x3bd9e271_u32, 0x07f1f67b_u32, 0x0f0a058c_u32,
    0x31d5e472_u32, 0x171a0d88_u32, 0x0efff1f6_u32, 0xfca8542a_u32,
    0x84f87c3e_u32, 0xd965bc5e_u32, 0xd29c4e27_u32, 0x89058c46_u32,
    0x2830180c_u32, 0x4389ca65_u32, 0x6dbdd068_u32, 0x5b99c261_u32,
    0x0a0c0603_u32, 0xbc239fc1_u32, 0xef41ae57_u32, 0xce7fb1d6_u32,
    0xec43afd9_u32, 0xcd7db058_u32, 0xea47add8_u32, 0x4985cc66_u32,
    0xc87bb3d7_u32, 0x9ce8743a_u32, 0x8a078dc8_u32, 0x88f0783c_u32,
    0x26cfe9fa_u32, 0x53623196_u32, 0xf5a653a7_u32, 0x775a2d98_u32,
    0x5297c5ec_u32, 0xb7da6db8_u32, 0xa83b93c7_u32, 0xc38241ae_u32,
    0x6bb9d269_u32, 0xa731964b_u32, 0xdd964bab_u32, 0xd19e4fa9_u32,
    0x4f81ce67_u32, 0x3c28140a_u32, 0x8f018e47_u32, 0x16eff9f2_u32,
    0x99ee77b5_u32, 0xcc884422_u32, 0x64b3d7e5_u32, 0x5e9fc1ee_u32,
    0xa3c261be_u32, 0xfaac562b_u32, 0x213e1f81_u32, 0x6c482412_u32,
    0x2d361b83_u32, 0x5a6c361b_u32, 0x24381c0e_u32, 0xca8c4623_u32,
    0x04f3f7f5_u32, 0x83098a45_u32, 0xc6844221_u32, 0x9e1f81ce_u32,
    0xab399249_u32, 0xe8b0582c_u32, 0x2cc3eff9_u32, 0x6ebfd1e6_u32,
    0x93e271b6_u32, 0xf0a05028_u32, 0x725c2e17_u32, 0x2b321982_u32,
    0x5c68341a_u32, 0x1d160b8b_u32, 0x3edfe1fe_u32, 0x1b12098a_u32,
    0x36241209_u32, 0x8c038fc9_u32, 0x35261387_u32, 0xb9259c4e_u32,
    0x7ca3dfe1_u32, 0xe4b85c2e_u32, 0x62b7d5e4_u32, 0x7aa7dde0_u32,
    0x408bcbeb_u32, 0x477a3d90_u32, 0xffaa55a4_u32, 0x44783c1e_u32,
    0x392e1785_u32, 0x5d9dc060_u32, 0x00000000_u32, 0xde944a25_u32,
    0x02f7f5f4_u32, 0x1ce3fff1_u32, 0x5f6a3594_u32, 0x3a2c160b_u32,
    0x68bbd3e7_u32, 0x23c9ea75_u32, 0x589bc3ef_u32, 0xb8d06834_u32,
    0xa6c46231_u32, 0xc277b5d4_u32, 0xda67bdd0_u32, 0x33221186_u32,
    0x19e5fc7e_u32, 0xc98e47ad_u32, 0x34d3e7fd_u32, 0xf6a45229_u32,
    0xa0c06030_u32, 0x9aec763b_u32, 0x6546239f_u32, 0x2ac7edf8_u32,
    0xae3f91c6_u32, 0x6a4c2613_u32, 0x14180c06_u32, 0x1e140a05_u32,
    0xa43397c5_u32, 0x66442211_u32, 0x2fc1ee77_u32, 0x15edf87c_u32,
    0x01f5f47a_u32, 0x0dfdf078_u32, 0xb4d86c36_u32, 0x4870381c_u32,
    0x96e47239_u32, 0xcb79b259_u32, 0x50603018_u32, 0xe945ac56_u32,
    0x8df67bb3_u32, 0x87fa7db0_u32, 0xd8904824_u32, 0xc0804020_u32,
    0x8bf279b2_u32, 0x4b723992_u32, 0xedb65ba3_u32, 0xba279dc0_u32,
    0x850d8844_u32, 0x5195c462_u32, 0x60402010_u32, 0x9fea75b4_u32,
    0x3f2a1584_u32, 0x97118643_u32, 0x4d763b93_u32, 0xb62f99c2_u32,
    0xa135944a_u32, 0xa9ce67bd_u32, 0x0506038f_u32, 0xeeb45a2d_u32,
    0xafca65bc_u32, 0x6f4a259c_u32, 0x61b5d46a_u32, 0x9d1d8040_u32,
    0x981b83cf_u32, 0xebb259a2_u32, 0x273a1d80_u32, 0xbf219e4f_u32,
    0x427c3e1f_u32, 0x860f89ca_u32, 0xdb9249aa_u32, 0x91158442_u32
  ]

  T4 = [
    0xbabababa_u32, 0x54545454_u32, 0x2f2f2f2f_u32, 0x74747474_u32,
    0x53535353_u32, 0xd3d3d3d3_u32, 0xd2d2d2d2_u32, 0x4d4d4d4d_u32,
    0x50505050_u32, 0xacacacac_u32, 0x8d8d8d8d_u32, 0xbfbfbfbf_u32,
    0x70707070_u32, 0x52525252_u32, 0x9a9a9a9a_u32, 0x4c4c4c4c_u32,
    0xeaeaeaea_u32, 0xd5d5d5d5_u32, 0x97979797_u32, 0xd1d1d1d1_u32,
    0x33333333_u32, 0x51515151_u32, 0x5b5b5b5b_u32, 0xa6a6a6a6_u32,
    0xdededede_u32, 0x48484848_u32, 0xa8a8a8a8_u32, 0x99999999_u32,
    0xdbdbdbdb_u32, 0x32323232_u32, 0xb7b7b7b7_u32, 0xfcfcfcfc_u32,
    0xe3e3e3e3_u32, 0x9e9e9e9e_u32, 0x91919191_u32, 0x9b9b9b9b_u32,
    0xe2e2e2e2_u32, 0xbbbbbbbb_u32, 0x41414141_u32, 0x6e6e6e6e_u32,
    0xa5a5a5a5_u32, 0xcbcbcbcb_u32, 0x6b6b6b6b_u32, 0x95959595_u32,
    0xa1a1a1a1_u32, 0xf3f3f3f3_u32, 0xb1b1b1b1_u32, 0x02020202_u32,
    0xcccccccc_u32, 0xc4c4c4c4_u32, 0x1d1d1d1d_u32, 0x14141414_u32,
    0xc3c3c3c3_u32, 0x63636363_u32, 0xdadadada_u32, 0x5d5d5d5d_u32,
    0x5f5f5f5f_u32, 0xdcdcdcdc_u32, 0x7d7d7d7d_u32, 0xcdcdcdcd_u32,
    0x7f7f7f7f_u32, 0x5a5a5a5a_u32, 0x6c6c6c6c_u32, 0x5c5c5c5c_u32,
    0xf7f7f7f7_u32, 0x26262626_u32, 0xffffffff_u32, 0xedededed_u32,
    0xe8e8e8e8_u32, 0x9d9d9d9d_u32, 0x6f6f6f6f_u32, 0x8e8e8e8e_u32,
    0x19191919_u32, 0xa0a0a0a0_u32, 0xf0f0f0f0_u32, 0x89898989_u32,
    0x0f0f0f0f_u32, 0x07070707_u32, 0xafafafaf_u32, 0xfbfbfbfb_u32,
    0x08080808_u32, 0x15151515_u32, 0x0d0d0d0d_u32, 0x04040404_u32,
    0x01010101_u32, 0x64646464_u32, 0xdfdfdfdf_u32, 0x76767676_u32,
    0x79797979_u32, 0xdddddddd_u32, 0x3d3d3d3d_u32, 0x16161616_u32,
    0x3f3f3f3f_u32, 0x37373737_u32, 0x6d6d6d6d_u32, 0x38383838_u32,
    0xb9b9b9b9_u32, 0x73737373_u32, 0xe9e9e9e9_u32, 0x35353535_u32,
    0x55555555_u32, 0x71717171_u32, 0x7b7b7b7b_u32, 0x8c8c8c8c_u32,
    0x72727272_u32, 0x88888888_u32, 0xf6f6f6f6_u32, 0x2a2a2a2a_u32,
    0x3e3e3e3e_u32, 0x5e5e5e5e_u32, 0x27272727_u32, 0x46464646_u32,
    0x0c0c0c0c_u32, 0x65656565_u32, 0x68686868_u32, 0x61616161_u32,
    0x03030303_u32, 0xc1c1c1c1_u32, 0x57575757_u32, 0xd6d6d6d6_u32,
    0xd9d9d9d9_u32, 0x58585858_u32, 0xd8d8d8d8_u32, 0x66666666_u32,
    0xd7d7d7d7_u32, 0x3a3a3a3a_u32, 0xc8c8c8c8_u32, 0x3c3c3c3c_u32,
    0xfafafafa_u32, 0x96969696_u32, 0xa7a7a7a7_u32, 0x98989898_u32,
    0xecececec_u32, 0xb8b8b8b8_u32, 0xc7c7c7c7_u32, 0xaeaeaeae_u32,
    0x69696969_u32, 0x4b4b4b4b_u32, 0xabababab_u32, 0xa9a9a9a9_u32,
    0x67676767_u32, 0x0a0a0a0a_u32, 0x47474747_u32, 0xf2f2f2f2_u32,
    0xb5b5b5b5_u32, 0x22222222_u32, 0xe5e5e5e5_u32, 0xeeeeeeee_u32,
    0xbebebebe_u32, 0x2b2b2b2b_u32, 0x81818181_u32, 0x12121212_u32,
    0x83838383_u32, 0x1b1b1b1b_u32, 0x0e0e0e0e_u32, 0x23232323_u32,
    0xf5f5f5f5_u32, 0x45454545_u32, 0x21212121_u32, 0xcececece_u32,
    0x49494949_u32, 0x2c2c2c2c_u32, 0xf9f9f9f9_u32, 0xe6e6e6e6_u32,
    0xb6b6b6b6_u32, 0x28282828_u32, 0x17171717_u32, 0x82828282_u32,
    0x1a1a1a1a_u32, 0x8b8b8b8b_u32, 0xfefefefe_u32, 0x8a8a8a8a_u32,
    0x09090909_u32, 0xc9c9c9c9_u32, 0x87878787_u32, 0x4e4e4e4e_u32,
    0xe1e1e1e1_u32, 0x2e2e2e2e_u32, 0xe4e4e4e4_u32, 0xe0e0e0e0_u32,
    0xebebebeb_u32, 0x90909090_u32, 0xa4a4a4a4_u32, 0x1e1e1e1e_u32,
    0x85858585_u32, 0x60606060_u32, 0x00000000_u32, 0x25252525_u32,
    0xf4f4f4f4_u32, 0xf1f1f1f1_u32, 0x94949494_u32, 0x0b0b0b0b_u32,
    0xe7e7e7e7_u32, 0x75757575_u32, 0xefefefef_u32, 0x34343434_u32,
    0x31313131_u32, 0xd4d4d4d4_u32, 0xd0d0d0d0_u32, 0x86868686_u32,
    0x7e7e7e7e_u32, 0xadadadad_u32, 0xfdfdfdfd_u32, 0x29292929_u32,
    0x30303030_u32, 0x3b3b3b3b_u32, 0x9f9f9f9f_u32, 0xf8f8f8f8_u32,
    0xc6c6c6c6_u32, 0x13131313_u32, 0x06060606_u32, 0x05050505_u32,
    0xc5c5c5c5_u32, 0x11111111_u32, 0x77777777_u32, 0x7c7c7c7c_u32,
    0x7a7a7a7a_u32, 0x78787878_u32, 0x36363636_u32, 0x1c1c1c1c_u32,
    0x39393939_u32, 0x59595959_u32, 0x18181818_u32, 0x56565656_u32,
    0xb3b3b3b3_u32, 0xb0b0b0b0_u32, 0x24242424_u32, 0x20202020_u32,
    0xb2b2b2b2_u32, 0x92929292_u32, 0xa3a3a3a3_u32, 0xc0c0c0c0_u32,
    0x44444444_u32, 0x62626262_u32, 0x10101010_u32, 0xb4b4b4b4_u32,
    0x84848484_u32, 0x43434343_u32, 0x93939393_u32, 0xc2c2c2c2_u32,
    0x4a4a4a4a_u32, 0xbdbdbdbd_u32, 0x8f8f8f8f_u32, 0x2d2d2d2d_u32,
    0xbcbcbcbc_u32, 0x9c9c9c9c_u32, 0x6a6a6a6a_u32, 0x40404040_u32,
    0xcfcfcfcf_u32, 0xa2a2a2a2_u32, 0x80808080_u32, 0x4f4f4f4f_u32,
    0x1f1f1f1f_u32, 0xcacacaca_u32, 0xaaaaaaaa_u32, 0x42424242_u32
  ]

  T5 = [
    0x00000000_u32, 0x01020608_u32, 0x02040c10_u32, 0x03060a18_u32,
    0x04081820_u32, 0x050a1e28_u32, 0x060c1430_u32, 0x070e1238_u32,
    0x08103040_u32, 0x09123648_u32, 0x0a143c50_u32, 0x0b163a58_u32,
    0x0c182860_u32, 0x0d1a2e68_u32, 0x0e1c2470_u32, 0x0f1e2278_u32,
    0x10206080_u32, 0x11226688_u32, 0x12246c90_u32, 0x13266a98_u32,
    0x142878a0_u32, 0x152a7ea8_u32, 0x162c74b0_u32, 0x172e72b8_u32,
    0x183050c0_u32, 0x193256c8_u32, 0x1a345cd0_u32, 0x1b365ad8_u32,
    0x1c3848e0_u32, 0x1d3a4ee8_u32, 0x1e3c44f0_u32, 0x1f3e42f8_u32,
    0x2040c01d_u32, 0x2142c615_u32, 0x2244cc0d_u32, 0x2346ca05_u32,
    0x2448d83d_u32, 0x254ade35_u32, 0x264cd42d_u32, 0x274ed225_u32,
    0x2850f05d_u32, 0x2952f655_u32, 0x2a54fc4d_u32, 0x2b56fa45_u32,
    0x2c58e87d_u32, 0x2d5aee75_u32, 0x2e5ce46d_u32, 0x2f5ee265_u32,
    0x3060a09d_u32, 0x3162a695_u32, 0x3264ac8d_u32, 0x3366aa85_u32,
    0x3468b8bd_u32, 0x356abeb5_u32, 0x366cb4ad_u32, 0x376eb2a5_u32,
    0x387090dd_u32, 0x397296d5_u32, 0x3a749ccd_u32, 0x3b769ac5_u32,
    0x3c7888fd_u32, 0x3d7a8ef5_u32, 0x3e7c84ed_u32, 0x3f7e82e5_u32,
    0x40809d3a_u32, 0x41829b32_u32, 0x4284912a_u32, 0x43869722_u32,
    0x4488851a_u32, 0x458a8312_u32, 0x468c890a_u32, 0x478e8f02_u32,
    0x4890ad7a_u32, 0x4992ab72_u32, 0x4a94a16a_u32, 0x4b96a762_u32,
    0x4c98b55a_u32, 0x4d9ab352_u32, 0x4e9cb94a_u32, 0x4f9ebf42_u32,
    0x50a0fdba_u32, 0x51a2fbb2_u32, 0x52a4f1aa_u32, 0x53a6f7a2_u32,
    0x54a8e59a_u32, 0x55aae392_u32, 0x56ace98a_u32, 0x57aeef82_u32,
    0x58b0cdfa_u32, 0x59b2cbf2_u32, 0x5ab4c1ea_u32, 0x5bb6c7e2_u32,
    0x5cb8d5da_u32, 0x5dbad3d2_u32, 0x5ebcd9ca_u32, 0x5fbedfc2_u32,
    0x60c05d27_u32, 0x61c25b2f_u32, 0x62c45137_u32, 0x63c6573f_u32,
    0x64c84507_u32, 0x65ca430f_u32, 0x66cc4917_u32, 0x67ce4f1f_u32,
    0x68d06d67_u32, 0x69d26b6f_u32, 0x6ad46177_u32, 0x6bd6677f_u32,
    0x6cd87547_u32, 0x6dda734f_u32, 0x6edc7957_u32, 0x6fde7f5f_u32,
    0x70e03da7_u32, 0x71e23baf_u32, 0x72e431b7_u32, 0x73e637bf_u32,
    0x74e82587_u32, 0x75ea238f_u32, 0x76ec2997_u32, 0x77ee2f9f_u32,
    0x78f00de7_u32, 0x79f20bef_u32, 0x7af401f7_u32, 0x7bf607ff_u32,
    0x7cf815c7_u32, 0x7dfa13cf_u32, 0x7efc19d7_u32, 0x7ffe1fdf_u32,
    0x801d2774_u32, 0x811f217c_u32, 0x82192b64_u32, 0x831b2d6c_u32,
    0x84153f54_u32, 0x8517395c_u32, 0x86113344_u32, 0x8713354c_u32,
    0x880d1734_u32, 0x890f113c_u32, 0x8a091b24_u32, 0x8b0b1d2c_u32,
    0x8c050f14_u32, 0x8d07091c_u32, 0x8e010304_u32, 0x8f03050c_u32,
    0x903d47f4_u32, 0x913f41fc_u32, 0x92394be4_u32, 0x933b4dec_u32,
    0x94355fd4_u32, 0x953759dc_u32, 0x963153c4_u32, 0x973355cc_u32,
    0x982d77b4_u32, 0x992f71bc_u32, 0x9a297ba4_u32, 0x9b2b7dac_u32,
    0x9c256f94_u32, 0x9d27699c_u32, 0x9e216384_u32, 0x9f23658c_u32,
    0xa05de769_u32, 0xa15fe161_u32, 0xa259eb79_u32, 0xa35bed71_u32,
    0xa455ff49_u32, 0xa557f941_u32, 0xa651f359_u32, 0xa753f551_u32,
    0xa84dd729_u32, 0xa94fd121_u32, 0xaa49db39_u32, 0xab4bdd31_u32,
    0xac45cf09_u32, 0xad47c901_u32, 0xae41c319_u32, 0xaf43c511_u32,
    0xb07d87e9_u32, 0xb17f81e1_u32, 0xb2798bf9_u32, 0xb37b8df1_u32,
    0xb4759fc9_u32, 0xb57799c1_u32, 0xb67193d9_u32, 0xb77395d1_u32,
    0xb86db7a9_u32, 0xb96fb1a1_u32, 0xba69bbb9_u32, 0xbb6bbdb1_u32,
    0xbc65af89_u32, 0xbd67a981_u32, 0xbe61a399_u32, 0xbf63a591_u32,
    0xc09dba4e_u32, 0xc19fbc46_u32, 0xc299b65e_u32, 0xc39bb056_u32,
    0xc495a26e_u32, 0xc597a466_u32, 0xc691ae7e_u32, 0xc793a876_u32,
    0xc88d8a0e_u32, 0xc98f8c06_u32, 0xca89861e_u32, 0xcb8b8016_u32,
    0xcc85922e_u32, 0xcd879426_u32, 0xce819e3e_u32, 0xcf839836_u32,
    0xd0bddace_u32, 0xd1bfdcc6_u32, 0xd2b9d6de_u32, 0xd3bbd0d6_u32,
    0xd4b5c2ee_u32, 0xd5b7c4e6_u32, 0xd6b1cefe_u32, 0xd7b3c8f6_u32,
    0xd8adea8e_u32, 0xd9afec86_u32, 0xdaa9e69e_u32, 0xdbabe096_u32,
    0xdca5f2ae_u32, 0xdda7f4a6_u32, 0xdea1febe_u32, 0xdfa3f8b6_u32,
    0xe0dd7a53_u32, 0xe1df7c5b_u32, 0xe2d97643_u32, 0xe3db704b_u32,
    0xe4d56273_u32, 0xe5d7647b_u32, 0xe6d16e63_u32, 0xe7d3686b_u32,
    0xe8cd4a13_u32, 0xe9cf4c1b_u32, 0xeac94603_u32, 0xebcb400b_u32,
    0xecc55233_u32, 0xedc7543b_u32, 0xeec15e23_u32, 0xefc3582b_u32,
    0xf0fd1ad3_u32, 0xf1ff1cdb_u32, 0xf2f916c3_u32, 0xf3fb10cb_u32,
    0xf4f502f3_u32, 0xf5f704fb_u32, 0xf6f10ee3_u32, 0xf7f308eb_u32,
    0xf8ed2a93_u32, 0xf9ef2c9b_u32, 0xfae92683_u32, 0xfbeb208b_u32,
    0xfce532b3_u32, 0xfde734bb_u32, 0xfee13ea3_u32, 0xffe338ab_u32
  ]

  class Cipher
    @round_key_enc : Array(Array(UInt32))
    @round_key_dec : Array(Array(UInt32))
    @n : Int32

    def initialize(key : Bytes)
      @round_key_enc = [] of Array(UInt32)
      @round_key_dec = [] of Array(UInt32)
      @n = key.size // 4
      
      key_setup(key)
    end

    private def rot(value : UInt32, r : Int32) : UInt32
      return value if r == 0
      (value >> r) & 0xffffffff_u32
    end

    private def get_byte(value : UInt32, pos : Int32) : UInt32
      ((value >> pos) & 0xff).to_u32
    end

    private def key_setup(key : Bytes)
      if @n < 4 || @n > 10
        raise "Invalid Anubis key size: #{32 * @n} bits"
      end

      kappa = Array(UInt32).new(@n, 0_u32)
      inter = Array(UInt32).new(@n, 0_u32)
      r = 8 + @n

      pos = 0
      @n.times do |i|
        kappa[i] = (
          (key[pos].to_u32! << 24) |
          (key[pos + 1].to_u32! << 16) |
          (key[pos + 2].to_u32! << 8) |
          key[pos + 3].to_u32!
        ) & 0xffffffff_u32
        pos += 4
      end

      (r + 1).times do |round|
        k0 = T4[rot(kappa[@n - 1], 24)]
        k1 = T4[get_byte(kappa[@n - 1], 16)]
        k2 = T4[get_byte(kappa[@n - 1], 8)]
        k3 = T4[kappa[@n - 1] & 0xff]

        (@n - 2).downto(0) do |t|
          k0 = (T4[rot(kappa[t], 24)] ^
               (T5[rot(k0, 24)] & 0xff000000_u32) ^
               (T5[get_byte(k0, 16)] & 0x00ff0000_u32) ^
               (T5[get_byte(k0, 8)] & 0x0000ff00_u32) ^
               (T5[k0 & 0xff] & 0x000000ff_u32)) & 0xffffffff_u32

          k1 = (T4[get_byte(kappa[t], 16)] ^
               (T5[rot(k1, 24)] & 0xff000000_u32) ^
               (T5[get_byte(k1, 16)] & 0x00ff0000_u32) ^
               (T5[get_byte(k1, 8)] & 0x0000ff00_u32) ^
               (T5[k1 & 0xff] & 0x000000ff_u32)) & 0xffffffff_u32

          k2 = (T4[get_byte(kappa[t], 8)] ^
               (T5[rot(k2, 24)] & 0xff000000_u32) ^
               (T5[get_byte(k2, 16)] & 0x00ff0000_u32) ^
               (T5[get_byte(k2, 8)] & 0x0000ff00_u32) ^
               (T5[k2 & 0xff] & 0x000000ff_u32)) & 0xffffffff_u32

          k3 = (T4[kappa[t] & 0xff] ^
               (T5[rot(k3, 24)] & 0xff000000_u32) ^
               (T5[get_byte(k3, 16)] & 0x00ff0000_u32) ^
               (T5[get_byte(k3, 8)] & 0x0000ff00_u32) ^
               (T5[k3 & 0xff] & 0x000000ff_u32)) & 0xffffffff_u32
        end

        @round_key_enc << [k0, k1, k2, k3]

        @n.times do |i|
          idx1 = (i + @n - 1) % @n
          idx2 = (i + @n - 2) % @n
          idx3 = (i + @n - 3) % @n
          
          inter[i] = (T0[rot(kappa[i], 24)] ^
                     T1[get_byte(kappa[idx1], 16)] ^
                     T2[get_byte(kappa[idx2], 8)] ^
                     T3[kappa[idx3] & 0xff]) & 0xffffffff_u32
        end

        kappa[0] = ((T0[4 * round] & 0xff000000_u32) ^
                   (T1[4 * round + 1] & 0x00ff0000_u32) ^
                   (T2[4 * round + 2] & 0x0000ff00_u32) ^
                   (T3[4 * round + 3] & 0x000000ff_u32) ^
                   inter[0]) & 0xffffffff_u32

        (1...@n).each do |i|
          kappa[i] = inter[i]
        end
      end

      # Setup decryption round keys
      @round_key_dec = Array.new(r + 1) { Array(UInt32).new(4, 0_u32) }
      @round_key_dec[0] = @round_key_enc[r]
      @round_key_dec[r] = @round_key_enc[0]

      (1...r).each do |round|
        4.times do |i|
          v = @round_key_enc[r - round][i]
          @round_key_dec[round][i] = (T0[T4[rot(v, 24)] & 0xff] ^
                                      T1[T4[get_byte(v, 16)] & 0xff] ^
                                      T2[T4[get_byte(v, 8)] & 0xff] ^
                                      T3[T4[v & 0xff] & 0xff]) & 0xffffffff_u32
        end
      end
    end

    def encrypt_block(block : Bytes) : Bytes
      crypt_block(block, @round_key_enc)
    end

    def decrypt_block(block : Bytes) : Bytes
      crypt_block(block, @round_key_dec)
    end

    private def crypt_block(block : Bytes, round_key : Array(Array(UInt32))) : Bytes
      raise "Block must be 16 bytes" if block.size != 16

      r = round_key.size - 1
      state = Array(UInt32).new(4, 0_u32)
      inter = Array(UInt32).new(4, 0_u32)

      pos = 0
      4.times do |i|
        state[i] = ((
          (block[pos].to_u32! << 24) |
          (block[pos + 1].to_u32! << 16) |
          (block[pos + 2].to_u32! << 8) |
          block[pos + 3].to_u32!
        ) ^ round_key[0][i]) & 0xffffffff_u32
        pos += 4
      end

      (1...r).each do |round|
        inter[0] = (T0[rot(state[0], 24)] ^ T1[rot(state[1], 24)] ^
                    T2[rot(state[2], 24)] ^ T3[rot(state[3], 24)] ^ round_key[round][0]) & 0xffffffff_u32
        inter[1] = (T0[get_byte(state[0], 16)] ^ T1[get_byte(state[1], 16)] ^
                    T2[get_byte(state[2], 16)] ^ T3[get_byte(state[3], 16)] ^ round_key[round][1]) & 0xffffffff_u32
        inter[2] = (T0[get_byte(state[0], 8)] ^ T1[get_byte(state[1], 8)] ^
                    T2[get_byte(state[2], 8)] ^ T3[get_byte(state[3], 8)] ^ round_key[round][2]) & 0xffffffff_u32
        inter[3] = (T0[state[0] & 0xff] ^ T1[state[1] & 0xff] ^
                    T2[state[2] & 0xff] ^ T3[state[3] & 0xff] ^ round_key[round][3]) & 0xffffffff_u32
        4.times { |i| state[i] = inter[i] }
      end

      inter[0] = ((T0[rot(state[0], 24)] & 0xff000000_u32) ^
                  (T1[rot(state[1], 24)] & 0x00ff0000_u32) ^
                  (T2[rot(state[2], 24)] & 0x0000ff00_u32) ^
                  (T3[rot(state[3], 24)] & 0x000000ff_u32) ^ round_key[r][0]) & 0xffffffff_u32
      inter[1] = ((T0[get_byte(state[0], 16)] & 0xff000000_u32) ^
                  (T1[get_byte(state[1], 16)] & 0x00ff0000_u32) ^
                  (T2[get_byte(state[2], 16)] & 0x0000ff00_u32) ^
                  (T3[get_byte(state[3], 16)] & 0x000000ff_u32) ^ round_key[r][1]) & 0xffffffff_u32
      inter[2] = ((T0[get_byte(state[0], 8)] & 0xff000000_u32) ^
                  (T1[get_byte(state[1], 8)] & 0x00ff0000_u32) ^
                  (T2[get_byte(state[2], 8)] & 0x0000ff00_u32) ^
                  (T3[get_byte(state[3], 8)] & 0x000000ff_u32) ^ round_key[r][2]) & 0xffffffff_u32
      inter[3] = ((T0[state[0] & 0xff] & 0xff000000_u32) ^
                  (T1[state[1] & 0xff] & 0x00ff0000_u32) ^
                  (T2[state[2] & 0xff] & 0x0000ff00_u32) ^
                  (T3[state[3] & 0xff] & 0x000000ff_u32) ^ round_key[r][3]) & 0xffffffff_u32

      result = Bytes.new(16)
      pos = 0
      4.times do |i|
        w = inter[i]
        result[pos] = ((w >> 24) & 0xff).to_u8
        result[pos + 1] = ((w >> 16) & 0xff).to_u8
        result[pos + 2] = ((w >> 8) & 0xff).to_u8
        result[pos + 3] = (w & 0xff).to_u8
        pos += 4
      end

      result
    end
  end

  class GCM
    BLOCK_SIZE = 16

    @cipher : Cipher
    @nonce : Bytes
    @tag_size : Int32
    @ghash_key : UInt128

    def initialize(@cipher, @nonce, @tag_size = 16)
      if @tag_size < 12 || @tag_size > 16
        raise "tag_size must be between 12 and 16 bytes"
      end

      zero_block = Bytes.new(BLOCK_SIZE, 0u8)
      encrypted_zero = @cipher.encrypt_block(zero_block)
      
      @ghash_key = bytes_to_uint128(encrypted_zero)
    end

    private def bytes_to_hex(bytes : Bytes) : String
      bytes.map { |b| b.to_s(16).rjust(2, '0') }.join
    end

    private def bytes_to_uint128(bytes : Bytes) : UInt128
      raise "Bytes must be 16 bytes" if bytes.size != 16
      
      result = 0_u128
      16.times do |i|
        result = (result << 8) | bytes[i].to_u128
      end
      result
    end

    private def uint128_to_bytes(value : UInt128) : Bytes
      bytes = Bytes.new(16)
      16.times do |i|
        bytes[15 - i] = (value & 0xFF).to_u8
        value >>= 8
      end
      bytes
    end

    private def ghash(data : Bytes) : Bytes
      return Bytes.new(BLOCK_SIZE, 0u8) if data.empty?

      # Pad data to multiple of 16 bytes
      data_copy = data
      if data_copy.size % BLOCK_SIZE != 0
        padding = BLOCK_SIZE - (data_copy.size % BLOCK_SIZE)
        temp = Bytes.new(data_copy.size + padding, 0u8)
        data_copy.size.times { |i| temp[i] = data_copy[i] }
        data_copy = temp
      end

      h = @ghash_key
      result = 0_u128

      i = 0
      while i < data_copy.size
        block = Bytes.new(BLOCK_SIZE)
        BLOCK_SIZE.times { |j| block[j] = data_copy[i + j] }
        block_int = bytes_to_uint128(block)
        result ^= block_int
        result = gmult(result, h)
        i += BLOCK_SIZE
      end

      uint128_to_bytes(result)
    end

    private def gmult(x : UInt128, y : UInt128) : UInt128
      z = 0_u128
      v = y
      r = 0xE1000000000000000000000000000000_u128

      128.times do |i|
        if ((x >> (127 - i)) & 1) == 1
          z ^= v
        end

        if (v & 1) == 1
          v >>= 1
          v ^= r
        else
          v >>= 1
        end
      end

      z
    end

    private def inc32(counter_block : Bytes) : Bytes
      counter = (counter_block[12].to_u32 << 24) |
                (counter_block[13].to_u32 << 16) |
                (counter_block[14].to_u32 << 8) |
                counter_block[15].to_u32
      
      counter = (counter + 1) & 0xFFFFFFFF

      result = Bytes.new(16)
      12.times { |i| result[i] = counter_block[i] }
      result[12] = ((counter >> 24) & 0xFF).to_u8
      result[13] = ((counter >> 16) & 0xFF).to_u8
      result[14] = ((counter >> 8) & 0xFF).to_u8
      result[15] = (counter & 0xFF).to_u8

      result
    end

    private def gctr(icb : Bytes, x : Bytes) : Bytes
      return Bytes.new(0) if x.empty?

      n = (x.size + BLOCK_SIZE - 1) // BLOCK_SIZE
      y = Bytes.new(x.size, 0u8)
      cb = Bytes.new(16)
      16.times { |i| cb[i] = icb[i] }

      n.times do |i|
        encrypted_cb = @cipher.encrypt_block(cb)

        block_size = (i == n - 1) ? (x.size % BLOCK_SIZE) : BLOCK_SIZE
        block_size = BLOCK_SIZE if block_size == 0

        x_start = i * BLOCK_SIZE
        y_start = i * BLOCK_SIZE

        block_size.times do |j|
          x_idx = x_start + j
          y_idx = y_start + j
          y[y_idx] = (x[x_idx] ^ encrypted_cb[j]).to_u8
        end

        cb = inc32(cb)
      end

      y
    end

    def encrypt(plaintext : Bytes, associated_data : Bytes = Bytes.new(0)) : {Bytes, Bytes}
      # Generate initial counter block
      if @nonce.size == 12
        icb = Bytes.new(16)
        @nonce.each_with_index { |b, i| icb[i] = b }
        icb[12] = 0u8; icb[13] = 0u8; icb[14] = 0u8; icb[15] = 1u8
      else
        s = (16 - (@nonce.size % 16)) % 16
        nonce_padded = Bytes.new(@nonce.size + s + 16, 0u8)
        
        @nonce.each_with_index { |b, i| nonce_padded[i] = b }
        
        len_nonce = @nonce.size.to_u64 * 8
        pos = @nonce.size + s + 8
        if pos + 7 < nonce_padded.size
          nonce_padded[pos] = ((len_nonce >> 56) & 0xFF).to_u8
          nonce_padded[pos + 1] = ((len_nonce >> 48) & 0xFF).to_u8
          nonce_padded[pos + 2] = ((len_nonce >> 40) & 0xFF).to_u8
          nonce_padded[pos + 3] = ((len_nonce >> 32) & 0xFF).to_u8
          nonce_padded[pos + 4] = ((len_nonce >> 24) & 0xFF).to_u8
          nonce_padded[pos + 5] = ((len_nonce >> 16) & 0xFF).to_u8
          nonce_padded[pos + 6] = ((len_nonce >> 8) & 0xFF).to_u8
          nonce_padded[pos + 7] = (len_nonce & 0xFF).to_u8
        end
        icb = ghash(nonce_padded)
      end

      cb = inc32(icb)
      ciphertext = gctr(cb, plaintext)

      # Compute tag
      len_a = associated_data.size.to_u64 * 8
      len_c = ciphertext.size.to_u64 * 8

      len_block = Bytes.new(16)
      len_block[0] = ((len_a >> 56) & 0xFF).to_u8
      len_block[1] = ((len_a >> 48) & 0xFF).to_u8
      len_block[2] = ((len_a >> 40) & 0xFF).to_u8
      len_block[3] = ((len_a >> 32) & 0xFF).to_u8
      len_block[4] = ((len_a >> 24) & 0xFF).to_u8
      len_block[5] = ((len_a >> 16) & 0xFF).to_u8
      len_block[6] = ((len_a >> 8) & 0xFF).to_u8
      len_block[7] = (len_a & 0xFF).to_u8
      len_block[8] = ((len_c >> 56) & 0xFF).to_u8
      len_block[9] = ((len_c >> 48) & 0xFF).to_u8
      len_block[10] = ((len_c >> 40) & 0xFF).to_u8
      len_block[11] = ((len_c >> 32) & 0xFF).to_u8
      len_block[12] = ((len_c >> 24) & 0xFF).to_u8
      len_block[13] = ((len_c >> 16) & 0xFF).to_u8
      len_block[14] = ((len_c >> 8) & 0xFF).to_u8
      len_block[15] = (len_c & 0xFF).to_u8

      # Pad A and C to block boundaries
      auth_data = associated_data
      if auth_data.size % BLOCK_SIZE != 0
        padding = BLOCK_SIZE - (auth_data.size % BLOCK_SIZE)
        temp = Bytes.new(auth_data.size + padding, 0u8)
        auth_data.size.times { |i| temp[i] = auth_data[i] }
        auth_data = temp
      end

      cipher_data = ciphertext
      if cipher_data.size % BLOCK_SIZE != 0
        padding = BLOCK_SIZE - (cipher_data.size % BLOCK_SIZE)
        temp = Bytes.new(cipher_data.size + padding, 0u8)
        cipher_data.size.times { |i| temp[i] = cipher_data[i] }
        cipher_data = temp
      end

      # GHASH input: A || C || len(A) || len(C)
      ghash_input = Bytes.new(auth_data.size + cipher_data.size + 16, 0u8)
      auth_data.size.times { |i| ghash_input[i] = auth_data[i] }
      
      cipher_data.size.times do |i|
        ghash_input[auth_data.size + i] = cipher_data[i]
      end
      
      16.times do |i|
        ghash_input[auth_data.size + cipher_data.size + i] = len_block[i]
      end

      s = ghash(ghash_input)
      
      tag_full = gctr(icb, s)
      tag = Bytes.new(@tag_size)
      @tag_size.times { |i| tag[i] = tag_full[i] }

      {ciphertext, tag}
    end

    def decrypt(ciphertext : Bytes, tag : Bytes, associated_data : Bytes = Bytes.new(0)) : Bytes?
      expected_tag = compute_tag(ciphertext, associated_data)
      
      return nil unless constant_time_compare(tag, expected_tag)

      if @nonce.size == 12
        icb = Bytes.new(16)
        @nonce.each_with_index { |b, i| icb[i] = b }
        icb[12] = 0u8; icb[13] = 0u8; icb[14] = 0u8; icb[15] = 1u8
      else
        s = (16 - (@nonce.size % 16)) % 16
        nonce_padded = Bytes.new(@nonce.size + s + 16, 0u8)
        
        @nonce.each_with_index { |b, i| nonce_padded[i] = b }
        
        len_nonce = @nonce.size.to_u64 * 8
        pos = @nonce.size + s + 8
        if pos + 7 < nonce_padded.size
          nonce_padded[pos] = ((len_nonce >> 56) & 0xFF).to_u8
          nonce_padded[pos + 1] = ((len_nonce >> 48) & 0xFF).to_u8
          nonce_padded[pos + 2] = ((len_nonce >> 40) & 0xFF).to_u8
          nonce_padded[pos + 3] = ((len_nonce >> 32) & 0xFF).to_u8
          nonce_padded[pos + 4] = ((len_nonce >> 24) & 0xFF).to_u8
          nonce_padded[pos + 5] = ((len_nonce >> 16) & 0xFF).to_u8
          nonce_padded[pos + 6] = ((len_nonce >> 8) & 0xFF).to_u8
          nonce_padded[pos + 7] = (len_nonce & 0xFF).to_u8
        end
        icb = ghash(nonce_padded)
      end

      cb = inc32(icb)
      gctr(cb, ciphertext)
    end

    private def compute_tag(ciphertext : Bytes, associated_data : Bytes) : Bytes
      len_a = associated_data.size.to_u64 * 8
      len_c = ciphertext.size.to_u64 * 8

      len_block = Bytes.new(16)
      len_block[0] = ((len_a >> 56) & 0xFF).to_u8
      len_block[1] = ((len_a >> 48) & 0xFF).to_u8
      len_block[2] = ((len_a >> 40) & 0xFF).to_u8
      len_block[3] = ((len_a >> 32) & 0xFF).to_u8
      len_block[4] = ((len_a >> 24) & 0xFF).to_u8
      len_block[5] = ((len_a >> 16) & 0xFF).to_u8
      len_block[6] = ((len_a >> 8) & 0xFF).to_u8
      len_block[7] = (len_a & 0xFF).to_u8
      len_block[8] = ((len_c >> 56) & 0xFF).to_u8
      len_block[9] = ((len_c >> 48) & 0xFF).to_u8
      len_block[10] = ((len_c >> 40) & 0xFF).to_u8
      len_block[11] = ((len_c >> 32) & 0xFF).to_u8
      len_block[12] = ((len_c >> 24) & 0xFF).to_u8
      len_block[13] = ((len_c >> 16) & 0xFF).to_u8
      len_block[14] = ((len_c >> 8) & 0xFF).to_u8
      len_block[15] = (len_c & 0xFF).to_u8

      # Pad A and C to block boundaries
      auth_data = associated_data
      if auth_data.size % BLOCK_SIZE != 0
        padding = BLOCK_SIZE - (auth_data.size % BLOCK_SIZE)
        temp = Bytes.new(auth_data.size + padding, 0u8)
        auth_data.size.times { |i| temp[i] = auth_data[i] }
        auth_data = temp
      end

      cipher_data = ciphertext
      if cipher_data.size % BLOCK_SIZE != 0
        padding = BLOCK_SIZE - (cipher_data.size % BLOCK_SIZE)
        temp = Bytes.new(cipher_data.size + padding, 0u8)
        cipher_data.size.times { |i| temp[i] = cipher_data[i] }
        cipher_data = temp
      end

      ghash_input = Bytes.new(auth_data.size + cipher_data.size + 16, 0u8)
      auth_data.size.times { |i| ghash_input[i] = auth_data[i] }
      
      cipher_data.size.times do |i|
        ghash_input[auth_data.size + i] = cipher_data[i]
      end
      
      16.times do |i|
        ghash_input[auth_data.size + cipher_data.size + i] = len_block[i]
      end

      s = ghash(ghash_input)
      
      if @nonce.size == 12
        icb = Bytes.new(16)
        @nonce.each_with_index { |b, i| icb[i] = b }
        icb[12] = 0u8; icb[13] = 0u8; icb[14] = 0u8; icb[15] = 1u8
      else
        s_val = (16 - (@nonce.size % 16)) % 16
        nonce_padded = Bytes.new(@nonce.size + s_val + 16, 0u8)
        @nonce.each_with_index { |b, i| nonce_padded[i] = b }
        len_nonce = @nonce.size.to_u64 * 8
        pos = @nonce.size + s_val + 8
        if pos + 7 < nonce_padded.size
          nonce_padded[pos] = ((len_nonce >> 56) & 0xFF).to_u8
          nonce_padded[pos + 1] = ((len_nonce >> 48) & 0xFF).to_u8
          nonce_padded[pos + 2] = ((len_nonce >> 40) & 0xFF).to_u8
          nonce_padded[pos + 3] = ((len_nonce >> 32) & 0xFF).to_u8
          nonce_padded[pos + 4] = ((len_nonce >> 24) & 0xFF).to_u8
          nonce_padded[pos + 5] = ((len_nonce >> 16) & 0xFF).to_u8
          nonce_padded[pos + 6] = ((len_nonce >> 8) & 0xFF).to_u8
          nonce_padded[pos + 7] = (len_nonce & 0xFF).to_u8
        end
        icb = ghash(nonce_padded)
      end

      tag_full = gctr(icb, s)
      tag = Bytes.new(@tag_size)
      @tag_size.times { |i| tag[i] = tag_full[i] }
      tag
    end

    private def constant_time_compare(a : Bytes, b : Bytes) : Bool
      return false if a.size != b.size
      result = 0
      a.size.times { |i| result |= a[i] ^ b[i] }
      result == 0
    end

    def nonce : Bytes
      @nonce
    end
  end

  class AEAD
    @key : Bytes
    @cipher : Cipher

    def initialize(@key)
      @cipher = Cipher.new(@key)
    end

    def nonce_size : Int32
      12
    end

    def overhead : Int32
      16
    end

    def seal(nonce : Bytes, plaintext : Bytes, associated_data : Bytes = Bytes.new(0)) : Bytes
      gcm = GCM.new(@cipher, nonce)
      ciphertext, tag = gcm.encrypt(plaintext, associated_data)
      
      result = Bytes.new(ciphertext.size + tag.size)
      ciphertext.size.times { |i| result[i] = ciphertext[i] }
      tag.size.times { |i| result[ciphertext.size + i] = tag[i] }
      result
    end

    def open(nonce : Bytes, ciphertext : Bytes, associated_data : Bytes = Bytes.new(0)) : Bytes?
      return nil if ciphertext.size < 16

      tag = Bytes.new(16)
      ciphertext_only = Bytes.new(ciphertext.size - 16, 0u8)
      
      (ciphertext.size - 16).times { |i| ciphertext_only[i] = ciphertext[i] }
      16.times { |i| tag[i] = ciphertext[ciphertext.size - 16 + i] }

      gcm = GCM.new(@cipher, nonce)
      gcm.decrypt(ciphertext_only, tag, associated_data)
    end
  end
end

