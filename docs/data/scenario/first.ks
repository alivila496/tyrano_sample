*start
[title name="標準模型キッチン：陽子作成"]
[hidemenubutton]
[freeimage layer="base"]
[bg storage="kitchen.png" time=500]

[iscript]
// 1. 変数の初期化（ゲーム開始時にリセット）
f.quarks_list = [];      // 選択されたクォークを格納する配列
f.boson_selected = "";   // 選択されたボゾン
f.total_count = 0;       // ★クォークの総数 (必須)
f.up_count = 0;          // ★Uクォークのカウント (必須)
f.down_count = 0;        // ★Dクォークのカウント (必須)
f.strange_count = 0;     // ★Sクォークのカウント (必須)
[endscript]

「今日の注文：安定した**中性子 (Neutron)** を作れ！」[l][r]
しかし材料のダウンクォークが足りないため陽子を作ってから崩壊させることで中性子を手に入れよう！[l][r]

[jump target=*select_fermion]

// -----------------------------------------------------
// 2. 選択した材料リストを表示するサブルーチン
// -----------------------------------------------------
*display_ingredients
[iscript]
// 各クォークの選択状況を表示用文字列に変換
f.display_u = "u×" + String(f.up_count);
f.display_d = "d×" + String(f.down_count);
f.display_s = "s×" + String(f.strange_count);

// 選択されたものだけを配列に入れて結合
var selected = [];
if (f.up_count > 0) selected.push(f.display_u);
if (f.down_count > 0) selected.push(f.display_d);
if (f.strange_count > 0) selected.push(f.display_s);

f.display_list = (selected.length > 0) ? selected.join(" , ") : "（まだ選択されていません）";
f.total_text = "合計: " + String(f.total_count) + " 個";
[endscript]
--- 現在のクォーク材料 ---[r]
&f.display_list;[r]
&f.total_text;[r]
------------------------------[l][r]
[return] 
// -----------------------------------------------------

// -----------------------------------------------------
// 3. フェルミオン（クォーク）選択ステップ
// -----------------------------------------------------
*select_fermion
[cm]

// 1. 材料リストを表示
[call target=*display_ingredients]

[iscript]
f.remaining_count = 3 - f.total_count;
f.remaining_text = "あと " + f.remaining_count + " 個の材料を選んでください。";
[endscript]

&f.remaining_text;[l][r]

[link target=*select_up] →アップクォーク (u) [endlink][r]
[link target=*select_down] →ダウンクォーク (d) [endlink][r]
[link target=*select_strange] →ストレンジクォーク (s) [endlink][r]
[link target=*select_electron] →電子 (e)  [endlink][r]
[s]

// クォーク選択時の処理（配列に要素を追加し、カウントアップ）
*select_up
[iscript]
f.quarks_list.push('u');
f.total_count = f.total_count + 1;
f.up_count = f.up_count + 1;
[endscript]
アップクォークを選びました。[jump target=*check_fermion_count]

*select_down
[iscript]
if (f.down_count >= 1) {
    f.down_limited = true;
} else {
    f.quarks_list.push('d');
    f.total_count = f.total_count + 1;
    f.down_count = f.down_count + 1;
}
[endscript]
[if exp="f.down_limited"]
ダウンクォークはこれ以上選べません。（1個のみ選択可）[l][r]
[jump target=*select_fermion]
[else]
ダウンクォークを選びました。[jump target=*check_fermion_count]
[endif]

*select_strange
[iscript]
f.quarks_list.push('s');
f.total_count = f.total_count + 1;
f.strange_count = f.strange_count + 1;
[endscript]
ストレンジクォークを選びました。[jump target=*check_fermion_count]

*select_electron
[cm]
電子（レプトン）はクォークではありません。陽子を作る材料には使えません。[l][r]
[jump target=*select_fermion] // 選択ステップに戻る

*check_fermion_count
[if exp="f.total_count >= 3"]
    [jump target=*select_boson] // 3個揃ったらボゾン選択へ
[else]
    [jump target=*select_fermion] // 3個未満ならループ
[endif]

// -----------------------------------------------------
// 4. ボゾン（結合力）選択ステップ
// -----------------------------------------------------
*select_boson
[cm]
[call target=*display_ingredients]

3つのクォークが揃いました。次に、それらを**ハドロン**として結合するための「力（ボゾン）」を選んでください。[l][r]

[link target=*boson_gluon] →グルーオン (g) [endlink] (強い力)[r]
[link target=*boson_photon] →光子 (γ) [endlink] (電磁気力)[r]
[link target=*boson_wz] →Wボゾン [endlink] (弱い力)[r]
[s]

*boson_gluon
[iscript]
f.boson_selected = "グルーオン (g)";
[endscript]
グルーオンを選択しました。強力な結合開始！[l][r]
[jump target=*combine_result]

*boson_photon
[iscript]
f.boson_selected = "光子 (γ)";
[endscript]
光子を選択しました。電磁気による結合開始！[l][r]
[jump target=*combine_result]

*boson_wz
[iscript]
f.boson_selected = "W/Zボゾン";
[endscript]
Wボゾンを選択しました。不安定な調理開始！[l][r]
[jump target=*combine_result]

// -----------------------------------------------------
// 5. 結果判定とエンディング
// -----------------------------------------------------
*combine_result
[cm]

[iscript]
// 組成による判定
f.is_proton = (f.up_count == 2 && f.down_count == 1 && f.strange_count == 0);
f.is_sigma  = (f.up_count == 2 && f.down_count == 0 && f.strange_count == 1);

// 結果表示用の文字列
f.boson_text = "力: " + f.boson_selected;
[endscript]

**最終確認**[r]
[call target=*display_ingredients]
&f.boson_text;[l][r]

[if exp="f.is_proton"]
    [jump target=*proton_end]
[endif]
[if exp="f.is_sigma"]
    [jump target=*sigma_end]
[endif]
[if exp="f.is_proton == false && f.is_sigma == false"]
    [jump target=*other_end]
[endif]

*proton_end
[bg storage="kitchen.png" time=500]
[cm]
見事、安定した**陽子 (Proton)** が完成しました！[l][r]
陽子をベータ崩壊させるための力を選んでください。[l][r]

[link target=*beta_decay_gluon] →グルーオン (g) [endlink][r]
[link target=*beta_decay_photon] →光子 (γ) [endlink][r]
[link target=*beta_decay_wz] →Wボゾン [endlink] 
[s]

*beta_decay_gluon
[iscript]
f.second_boson = "グルーオン (g)";
[endscript]
[jump target=*decay_result]

*beta_decay_photon
[iscript]
f.second_boson = "光子 (γ)";
[endscript]
[jump target=*decay_result]

*beta_decay_wz
[iscript]
f.second_boson = "Wボゾン";
[endscript]
[jump target=*decay_result]

*decay_result
[cm]
[iscript]
f.beta_success = (f.second_boson == "Wボゾン");
[endscript]

[if exp="f.beta_success"]
    [bg storage="true.png" time=500]
    見事、陽子が中性子に変換されました！[l][r]
    【 TRUE END 】[l][cm]
    [jump target=*start]
[endif]
[if exp="f.beta_success == false"]
    [bg storage="fail.png" time=500]
    力の選択が間違っていました。陽子の変換に失敗しました。[l][r]
    【 FAILED BETA DECAY END 】[l][cm]
[endif]
[jump target=*proton_end]

*sigma_end
[bg storage="kitchen.png" time=500]
[cm]
できたのは**シグマ中間子 (Σ)** です。[l][r]
これは中間子/バリオンの仲間です。[l][r]
シグマ中間子を崩壊させるための力を選んで崩壊させてください。[l][r]

[link target=*sigma_decay_gluon] →グルーオン (g) [endlink][r]
[link target=*sigma_decay_photon] →光子 (γ) [endlink][r]
[link target=*sigma_decay_wz] →Wボゾン [endlink] (W)[r]
[s]

*sigma_decay_gluon
[iscript]
f.second_boson = "グルーオン (g)";
[endscript]
[jump target=*sigma_decay_result]

*sigma_decay_photon
[iscript]
f.second_boson = "光子 (γ)";
[endscript]
[jump target=*sigma_decay_result]

*sigma_decay_wz
[iscript]
f.second_boson = "Wボゾン";
[endscript]
[jump target=*sigma_decay_result]

*sigma_decay_result
[cm]
[iscript]
f.sigma_decay_success = (f.second_boson == "Wボゾン");
[endscript]

[if exp="f.sigma_decay_success"]
    [bg storage="hidden.png" time=500]
    見事、シグマ中間子が崩壊し中性子が得られました！[l][r]
    【 HIDDEN END 】[l][cm]
    [jump target=*start]
[endif]
[if exp="f.sigma_decay_success == false"]
    [bg storage="fail.png" time=500]
    力の選択が間違っていました。崩壊に失敗しました。[l][r]
    【 FAILED SIGMA DECAY END 】[l][cm]
[endif]
[jump target=*sigma_decay_end]

*other_end
[bg storage="kitchen.png" time=500]
[cm]
この組み合わせでは目標の粒子は作れませんでした。[l][r]
[bg storage="fail.png" time=500]
【 BAD END 】[l][cm]
[jump target=*start]