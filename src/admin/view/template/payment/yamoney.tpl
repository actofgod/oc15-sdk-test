<?php echo $header; ?>
    <link rel="stylesheet" href="https://yastatic.net/bootstrap/3.3.6/css/bootstrap.min.css">
    <div id="content" class="container">
        <div class="row">
            <h3 class="form-heading"><?php echo $lang->get('module_settings_header'); ?></h3>
            <div class='col-md-12'>
                <p><?php echo $lang->get('module_license'); ?></p>
                <p><?php echo $lang->get('module_version'); ?> <span id='ya_version'><?php echo $yamoney_version; ?></span></p>
            </div>
        </div>

        <?php if (isset($attention) || isset($success) || !empty($errors)) : ?>
        <div class='row'>
            <?php if (isset($attention)) : ?>
            <div class='col-md-12'>
                <div class="attention"><?php echo $attention; ?></div>
            </div>
            <?php endif; ?>
            <?php if (isset($success)) : ?>
            <div class='col-md-12'>
                <div class="success"><?php echo $success; ?></div>
            </div>
            <?php endif; ?>
            <?php if (!empty($errors)) : ?>
            <div class='col-md-12'>
                <?php foreach ($errors as $error) : ?>
                    <div class="warning"><?php echo $error; ?></div>
                <?php endforeach; ?>
            </div>
            <?php endif; ?>
        </div>
        <?php endif; ?>

        <?php if ($kassa->isTestMode() && $kassa->isEnabled()) : ?>
        <div class='row'>
            <div class='col-md-12'>
                <div class="attention" style="background-color:#efefff;border-color:#afafff;"><?php echo $lang->get('kassa_test_mode_info'); ?></div>
            </div>
        </div>
        <?php endif; ?>

        <!-- Навигация -->
        <form action="<?php echo $action; ?>" method="post" id="form">
            <ul class="nav nav-tabs" role="tablist">
                <li id="tabKassa" class="active"><a href="#kassa" class="my-tabs" aria-controls="kassa" role="tab" data-toggle="tab"><?php echo $lang->get('kassa_tab_label'); ?></a></li>
                <li id="tabMoney"><a href="#money" class="my-tabs" aria-controls="kassa" role="tab" data-toggle="tab"><?php echo $lang->get('wallet_tab_label'); ?></a></li>
                <li id="tabBilling"><a href="#yabilling" class="my-tabs" aria-controls="kassa" role="tab" data-toggle="tab"><?php echo $lang->get('tab_billing'); ?></a></li>
                <li id="tabUpdater"><a href="#updater" class="my-tabs" aria-controls="kassa" role="tab" data-toggle="tab"><?php echo $lang->get('tab_updater'); ?></a></li>
                <div class="buttons text-right">
                    <a onclick="$('#form').submit();" class="button"><?php echo $lang->get('button_save'); ?></a>
                    <a href="<?php echo $cancel; ?>" class="button"><?php echo $lang->get('button_cancel'); ?></a>
                </div>
            </ul>
            <div class="tab-content">
                <?php include dirname(__FILE__) . '/yamoney/kassa.php'; ?>
                <?php include dirname(__FILE__) . '/yamoney/wallet.php'; ?>
                <?php include dirname(__FILE__) . '/yamoney/billing.php'; ?>
                <?php if ($zip_enabled && $curl_enabled): ?>
                <?php include dirname(__FILE__) . '/yamoney/updater.php'; ?>
                <?php else: ?>
                <?php include dirname(__FILE__) . '/yamoney/updater_disabled.php'; ?>
                <?php endif; ?>
            </div> <!-- для tab-контента -->
        </form>
        <?php if (isset($update_action)) : ?>
            <?php if (isset($newVersion)) : ?>
                <form method="post" id="update-form" action="<?php echo $update_action; ?>&type=update">
                    <input name="update" value="1" type="hidden" />
                    <input name="version" value="<?php echo htmlspecialchars($newVersion) ?>" type="hidden" />
                </form>
            <?php endif; ?>
            <form method="post" id="check-version" action="<?php echo $update_action; ?>&type=check">
                <input name="force" value="1" type="hidden" />
            </form>
        <?php endif; ?>
        <?php if (isset($backup_action)) : ?>
            <form id="action-form" method="post" action="<?php echo $backup_action; ?>">
                <input type="hidden" name="action" id="action-form-action" value="none" />
                <input type="hidden" name="file_name" id="action-form-file-name" value="" />
                <input type="hidden" name="version" id="action-form-version" value="" />
            </form>
        <?php endif; ?>
    </div> <!-- есть в footer -->
<script>
    $(document).ready(function( $ ) {
        $('.my-tabs').click(function (e) {
            e.preventDefault();

            var panelOptions = {
                money: {
                    tabName: "tabMoney",
                    show: [
                        "ya-new-status",
                        "ya-success-page"
                    ]
                },
                kassa: {
                    tabName: "tabKassa",
                    show: [
                        "ya-new-status",
                        "ya-success-page"
                    ]
                },
                yabilling: {
                    tabName: "tabBilling",
                    hide: [
                        "ya-new-status",
                        "ya-success-page"
                    ]
                },
                updater: {
                    tabName: "tabUpdater"
                }
            };

            var active = $(this).attr("href");
            for (var type in panelOptions) {
                var id = "#" + type;
                if (id == active) {
                    $("#" + panelOptions[type].tabName).addClass("active");
                    $(id).show();
                    if (panelOptions[type].hasOwnProperty("show")) {
                        _eachCall(panelOptions[type].show, "show");
                    }
                    if (panelOptions[type].hasOwnProperty("hide")) {
                        _eachCall(panelOptions[type].hide, "hide");
                    }
                } else {
                    $("#" + panelOptions[type].tabName).removeClass("active");
                    $(id).hide();
                }
            }

            function _eachCall(list, method) {
                for (var i = 0; i < list.length; i++) {
                    id = "#" + list[i];
                    $(id)[method]();
                }
            }
        });

        $(".ya_mode").click(function (e) {
            if (e.target.checked) {
                $(".ya_mode").each(function () {
                    if (this != e.target) {
                        this.checked = false;
                    }
                })
            }
        });

        $("li.active > a.my-tabs").trigger("click");
    });
</script>
<?php echo $footer; ?>