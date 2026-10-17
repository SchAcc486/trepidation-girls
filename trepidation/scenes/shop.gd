extends CanvasLayer

var sell = "";

func _process(_delta: float) -> void:
	$Shop/Sell/Polaroids/ItemFrame/TopRow/Polaroid/Amount.text = str(Globals.picture_taken);
	$Shop/Sell/Polaroids/ItemFrame/TopRow/PolaroidVariant/Amount.text = str(Globals.picture_variant_taken);
	$Shop/Money.text = "$" + str(Globals.money);

## shows buy options
func _on_buy_pressed() -> void:
	$Shop/Buy.visible = true;
	$Shop/Back.visible = true;
	$Shop/Options/Buy.visible = false;
	$Shop/Options/Sell.visible = false;
	$SFX/Click.play();

## shows sell options
func _on_sell_pressed() -> void:
	$Shop/Sell.visible = true;
	$Shop/Back.visible = true;
	$Shop/Options/Buy.visible = false;
	$Shop/Options/Sell.visible = false;
	$SFX/Click.play();

## goes back
func _on_back_pressed() -> void:
	$Shop/Buy.visible = false;
	$Shop/Sell.visible = false;
	$Shop/Back.visible = false;
	$Shop/Options/Buy.visible = true;
	$Shop/Options/Sell.visible = true;
	$Shop/Buy/TextBox.visible = false;
	$Shop/Sell/TextBox.visible = false;
	$SFX/Click.play();

## deletes shop
func _on_exit_pressed() -> void:
	var buttonsfx := $SFX/Click.duplicate();
	add_sibling(buttonsfx);
	buttonsfx.play();
	Globals.shop = false;
	call_deferred("queue_free");

## shows buying textbox
func _on_interact_pressed() -> void:
	$Shop/Buy/TextBox.visible = true;
	$SFX/Click.play();

## hides buying textbox
func _on_deny_pressed() -> void:
	$Shop/Buy/TextBox.visible = false;
	$Shop/Sell/TextBox.visible = false;
	$SFX/Click.play();

## checks if you can buy item
func _on_accept_pressed() -> void:
	$SFX/Click.play();
	if Globals.money >= 30.0:
		Globals.polaroids += 20;
		Globals.money -= 30.0;

## checks if normal polaroids are selected
func _on_polaroids_pressed() -> void:
	$SFX/Click.play();
	$Shop/Sell/TextBox.visible = true;
	$Shop/Sell/TextBox/Text.text = "Sell polaroids for $1?";
	sell = "polaroids";

## checks if special polaroids are selected
func _on_polaroid_variants_pressed() -> void:
	$SFX/Click.play();
	$Shop/Sell/TextBox.visible = true;
	$Shop/Sell/TextBox/Text.text = "Sell special polaroids for $10?";
	sell = "polaroids variant";

## sells item
func _on_yes_pressed() -> void:
	if sell == "polaroids" and Globals.picture_taken >= 1:
		$SFX/Click.play();
		Globals.money += 1;
		Globals.picture_taken -= 1;
	if sell == "polaroids variant" and Globals.picture_variant_taken >= 1:
		$SFX/Click.play();
		Globals.money += 10;
		Globals.picture_variant_taken -= 1;
