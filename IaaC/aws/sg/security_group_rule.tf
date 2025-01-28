resource "aws_security_group_rule" "tfer--sg-0b22ad61b9e0f9367_egress_-1_-1_-1_0-002E-0-002E-0-002E-0-002F-0" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "lambda"
  from_port         = "0"
  protocol          = "-1"
  security_group_id = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"
  to_port           = "0"
  type              = "egress"
}

resource "aws_security_group_rule" "tfer--sg-0b22ad61b9e0f9367_egress_tcp_443_443_0-002E-0-002E-0-002E-0-002F-0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "443"
  protocol          = "tcp"
  security_group_id = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"
  to_port           = "443"
  type              = "egress"
}

resource "aws_security_group_rule" "tfer--sg-0b22ad61b9e0f9367_ingress_tcp_22_22_0-002E-0-002E-0-002E-0-002F-0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  protocol          = "tcp"
  security_group_id = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"
  to_port           = "22"
  type              = "ingress"
}

resource "aws_security_group_rule" "tfer--sg-0b22ad61b9e0f9367_ingress_tcp_3306_3306_sg-0b02998105dcfc1bf" {
  description              = "Allow Lambda access only."
  from_port                = "3306"
  protocol                 = "tcp"
  security_group_id        = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"
  source_security_group_id = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--default_sg-0b02998105dcfc1bf_id}"
  to_port                  = "3306"
  type                     = "ingress"
}

resource "aws_security_group_rule" "tfer--sg-0b22ad61b9e0f9367_ingress_tcp_443_443_0-002E-0-002E-0-002E-0-002F-0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "443"
  protocol          = "tcp"
  security_group_id = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"
  to_port           = "443"
  type              = "ingress"
}

resource "aws_security_group_rule" "tfer--sg-0b22ad61b9e0f9367_ingress_tcp_80_80_0-002E-0-002E-0-002E-0-002F-0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "80"
  protocol          = "tcp"
  security_group_id = "${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--launch-wizard-2_sg-0b22ad61b9e0f9367_id}"
  to_port           = "80"
  type              = "ingress"
}
